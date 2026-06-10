from datetime import date as date_type
from django.db import transaction, IntegrityError
from .models import Slot, Booking


class ConflictError(Exception):
    pass


class BookingService:
    @staticmethod
    @transaction.atomic
    def create_booking(slot_id, user):
        if not slot_id:
            raise ValueError("slot_id is required")

        try:
            slot = Slot.objects.select_for_update().get(id=slot_id)
        except Slot.DoesNotExist:
            raise ValueError("Slot not found")

        if slot.date < date_type.today():
            raise ValueError("Cannot book a slot in the past")

        if slot.is_booked:
            raise ConflictError("This slot has already been booked by another user.")

        slot.is_booked = True
        slot.save()

        booking = Booking.objects.create(user=user, slot=slot)
        return booking

    @staticmethod
    @transaction.atomic
    def cancel_booking(booking_id, user):
        try:
            booking = Booking.objects.select_related('slot').get(id=booking_id)
        except Booking.DoesNotExist:
            raise ValueError("Booking not found")

        if booking.user_id != user.id:
            raise PermissionError("You can only cancel your own bookings")

        booking.slot.is_booked = False
        booking.slot.save()
        booking.delete()

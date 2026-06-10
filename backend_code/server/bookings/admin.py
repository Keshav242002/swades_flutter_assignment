from django.contrib import admin
from .models import User, Venue, Slot, Booking


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'email', 'firebase_uid', 'created_at')
    search_fields = ('name', 'email', 'firebase_uid')


@admin.register(Venue)
class VenueAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'sport_type', 'location', 'price_per_hour')
    list_filter = ('sport_type',)
    search_fields = ('name', 'location')


@admin.register(Slot)
class SlotAdmin(admin.ModelAdmin):
    list_display = ('id', 'venue', 'date', 'start_time', 'end_time', 'is_booked')
    list_filter = ('venue', 'date', 'is_booked')
    date_hierarchy = 'date'


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'slot', 'booked_at')
    list_filter = ('booked_at',)
    search_fields = ('user__name', 'user__email')

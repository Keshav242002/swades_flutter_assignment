part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class BookingFetchRequested extends BookingEvent {
  const BookingFetchRequested();
}

class BookingCancelRequested extends BookingEvent {
  final int bookingId;
  const BookingCancelRequested({required this.bookingId});
  @override
  List<Object?> get props => [bookingId];
}

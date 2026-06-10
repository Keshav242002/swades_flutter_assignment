part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingLoaded extends BookingState {
  final List<BookingModel> bookings;
  const BookingLoaded({required this.bookings});
  @override
  List<Object?> get props => [bookings];
}

class BookingCancelling extends BookingState {
  final List<BookingModel> bookings;
  final int cancellingId;
  const BookingCancelling({required this.bookings, required this.cancellingId});
  @override
  List<Object?> get props => [bookings, cancellingId];
}

class BookingEmpty extends BookingState {
  const BookingEmpty();
}

class BookingError extends BookingState {
  final String message;
  const BookingError({required this.message});
  @override
  List<Object?> get props => [message];
}

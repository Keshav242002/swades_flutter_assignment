import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/repositories/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;

  BookingBloc(this._bookingRepository) : super(const BookingInitial()) {
    on<BookingFetchRequested>(_onFetch);
    on<BookingCancelRequested>(_onCancel);
  }

  Future<void> _onFetch(BookingFetchRequested event, Emitter<BookingState> emit) async {
    emit(const BookingLoading());
    try {
      final result = await _bookingRepository.getMyBookings();
      if (result.bookings.isEmpty) {
        emit(const BookingEmpty());
      } else {
        emit(BookingLoaded(bookings: result.bookings, fromCache: result.fromCache));
      }
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  Future<void> _onCancel(BookingCancelRequested event, Emitter<BookingState> emit) async {
    List<BookingModel> current = [];
    if (state is BookingLoaded) {
      current = (state as BookingLoaded).bookings;
    } else if (state is BookingCancelling) {
      current = (state as BookingCancelling).bookings;
    }
    emit(BookingCancelling(bookings: current, cancellingId: event.bookingId));
    try {
      await _bookingRepository.cancelBooking(event.bookingId);
      final updated = current.where((b) => b.id != event.bookingId).toList();
      if (updated.isEmpty) {
        emit(const BookingEmpty());
      } else {
        emit(BookingLoaded(bookings: updated));
      }
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }
}

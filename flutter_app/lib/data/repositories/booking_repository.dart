import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepository(this._remoteDataSource);

  Future<BookingModel> bookSlot(int slotId) =>
      _remoteDataSource.createBooking(slotId);

  Future<List<BookingModel>> getMyBookings() =>
      _remoteDataSource.getMyBookings();

  Future<void> cancelBooking(int bookingId) =>
      _remoteDataSource.cancelBooking(bookingId);
}

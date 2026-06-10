import '../datasources/booking_remote_datasource.dart';
import '../datasources/booking_local_datasource.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;
  final BookingLocalDataSource _localDataSource;

  BookingRepository(this._remoteDataSource, this._localDataSource);

  Future<BookingModel> bookSlot(int slotId) =>
      _remoteDataSource.createBooking(slotId);

  Future<({List<BookingModel> bookings, bool fromCache})> getMyBookings() async {
    try {
      final bookings = await _remoteDataSource.getMyBookings();
      await _localDataSource.cacheBookings(bookings);
      return (bookings: bookings, fromCache: false);
    } catch (_) {
      final cached = await _localDataSource.getCachedBookings();
      if (cached != null) return (bookings: cached, fromCache: true);
      rethrow;
    }
  }

  Future<void> cancelBooking(int bookingId) =>
      _remoteDataSource.cancelBooking(bookingId);
}

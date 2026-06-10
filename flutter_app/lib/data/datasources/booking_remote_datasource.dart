import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/booking_model.dart';

class BookingRemoteDataSource {
  final ApiClient _client;

  BookingRemoteDataSource(this._client);

  Future<BookingModel> createBooking(int slotId) async {
    final response = await _client.post(
      ApiConstants.bookings,
      data: {'slot_id': slotId},
    );
    return BookingModel.fromJson(response.data);
  }

  Future<List<BookingModel>> getMyBookings() async {
    final response = await _client.get(ApiConstants.myBookings);
    return (response.data as List).map((e) => BookingModel.fromJson(e)).toList();
  }

  Future<void> cancelBooking(int bookingId) async {
    await _client.delete(ApiConstants.cancelBooking(bookingId));
  }
}

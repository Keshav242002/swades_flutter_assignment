import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/venue_model.dart';
import '../models/slot_model.dart';

class VenueRemoteDataSource {
  final ApiClient _client;

  VenueRemoteDataSource(this._client);

  Future<List<VenueModel>> getVenues() async {
    final response = await _client.get(ApiConstants.venues);
    return (response.data as List).map((e) => VenueModel.fromJson(e)).toList();
  }

  Future<List<SlotModel>> getSlots(int venueId, String date) async {
    final response = await _client.get(
      ApiConstants.venueSlots(venueId),
      queryParams: {'date': date},
    );
    return (response.data as List).map((e) => SlotModel.fromJson(e)).toList();
  }
}

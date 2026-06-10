import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/app_logger.dart';
import '../models/venue_model.dart';
import '../models/slot_model.dart';

class VenueRemoteDataSource {
  final ApiClient _client;

  VenueRemoteDataSource(this._client);

  Future<List<VenueModel>> getVenues() async {
    AppLogger.api('getVenues → GET ${ApiConstants.venues}');
    final response = await _client.get(ApiConstants.venues);
    final venues = (response.data as List).map((e) => VenueModel.fromJson(e)).toList();
    AppLogger.api('getVenues ✓ — ${venues.length} venues');
    return venues;
  }

  Future<List<SlotModel>> getSlots(int venueId, String date) async {
    AppLogger.api('getSlots → GET venue=$venueId date=$date');
    final response = await _client.get(
      ApiConstants.venueSlots(venueId),
      queryParams: {'date': date},
    );
    final slots = (response.data as List).map((e) => SlotModel.fromJson(e)).toList();
    AppLogger.api('getSlots ✓ — ${slots.length} slots');
    return slots;
  }

  Future<List<SlotModel>> getSlotsDelta(
      int venueId, String date, DateTime since) async {
    final sinceIso = since.toUtc().toIso8601String();
    AppLogger.api('getSlotsDelta → GET venue=$venueId date=$date since=$sinceIso');
    final response = await _client.get(
      ApiConstants.venueSlotsPoll(venueId),
      queryParams: {'date': date, 'since': sinceIso},
    );
    final slots = (response.data as List).map((e) => SlotModel.fromJson(e)).toList();
    AppLogger.api('getSlotsDelta ✓ — ${slots.length} changed slots');
    return slots;
  }
}

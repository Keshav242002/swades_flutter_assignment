import '../datasources/venue_remote_datasource.dart';
import '../models/venue_model.dart';
import '../models/slot_model.dart';

class VenueRepository {
  final VenueRemoteDataSource _remoteDataSource;

  VenueRepository(this._remoteDataSource);

  Future<List<VenueModel>> getVenues() => _remoteDataSource.getVenues();

  Future<List<SlotModel>> getSlots(int venueId, String date) =>
      _remoteDataSource.getSlots(venueId, date);
}

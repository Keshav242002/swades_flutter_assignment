import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/venue_model.dart';
import '../../../data/repositories/venue_repository.dart';

part 'venue_event.dart';
part 'venue_state.dart';

class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final VenueRepository _venueRepository;

  VenueBloc(this._venueRepository) : super(const VenueInitial()) {
    on<VenueFetchRequested>(_onFetch);
  }

  Future<void> _onFetch(VenueFetchRequested event, Emitter<VenueState> emit) async {
    emit(const VenueLoading());
    try {
      final venues = await _venueRepository.getVenues();
      if (venues.isEmpty) {
        emit(const VenueEmpty());
      } else {
        emit(VenueLoaded(venues: venues));
      }
    } catch (e) {
      emit(VenueError(message: e.toString()));
    }
  }
}

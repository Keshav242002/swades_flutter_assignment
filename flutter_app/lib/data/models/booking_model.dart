import 'package:equatable/equatable.dart';
import 'slot_model.dart';
import 'venue_model.dart';

class BookingModel extends Equatable {
  final int id;
  final SlotModel slot;
  final VenueModel venue;
  final DateTime bookedAt;

  const BookingModel({
    required this.id,
    required this.slot,
    required this.venue,
    required this.bookedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json['id'],
        slot: SlotModel.fromJson(json['slot']),
        venue: VenueModel.fromJson(json['venue']),
        bookedAt: DateTime.parse(json['booked_at']),
      );

  @override
  List<Object?> get props => [id, slot, venue, bookedAt];
}

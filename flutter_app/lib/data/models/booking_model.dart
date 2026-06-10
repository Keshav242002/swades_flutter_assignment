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

  Map<String, dynamic> toJson() => {
        'id': id,
        'slot': slot.toJson(),
        'venue': venue.toJson(),
        'booked_at': bookedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, slot, venue, bookedAt];
}

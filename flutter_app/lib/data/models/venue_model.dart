import 'package:equatable/equatable.dart';

class VenueModel extends Equatable {
  final int id;
  final String name;
  final String sportType;
  final String location;
  final String description;
  final String imageUrl;
  final double pricePerHour;

  const VenueModel({
    required this.id,
    required this.name,
    required this.sportType,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.pricePerHour,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) => VenueModel(
        id: json['id'],
        name: json['name'],
        sportType: json['sport_type'],
        location: json['location'] ?? '',
        description: json['description'] ?? '',
        imageUrl: json['image_url'] ?? '',
        pricePerHour: double.tryParse(json['price_per_hour']?.toString() ?? '') ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sport_type': sportType,
        'location': location,
        'description': description,
        'image_url': imageUrl,
        'price_per_hour': pricePerHour.toString(),
      };

  String get sportEmoji {
    switch (sportType.toLowerCase()) {
      case 'badminton':
        return '🏸';
      case 'football':
      case 'soccer':
        return '⚽';
      case 'cricket':
        return '🏏';
      case 'basketball':
        return '🏀';
      case 'tennis':
        return '🎾';
      case 'volleyball':
        return '🏐';
      default:
        return '🏅';
    }
  }

  @override
  List<Object?> get props => [id, name, sportType, location, description, imageUrl, pricePerHour];
}

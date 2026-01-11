import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final int id;
  final String name;
  final String? country;
  final String? admin1;

  const LocationModel({
    required this.id,
    required this.name,
    this.country,
    this.admin1,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
    );
  }

  String get displayName {
    final parts = [name, admin1, country].where((e) => e != null).toList();
    if (parts.length > 2) {
      // If we have name, admin1, and country, admin1 might be redundant if it's not well known,
      // but usually "City, State, Country" is good.
      return "${parts[0]}, ${parts[2]}"; // City, Country (simplified for cleaner UI)
    }
    return parts.join(", ");
  }

  String get fullDisplayName {
    return [name, country].where((e) => e != null).join(", ");
  }

  @override
  List<Object?> get props => [id, name, country, admin1];
}

import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

/**
 * Represents a location
 */
class Location extends Equatable {
  final double longitude, latitude;

  /// This is the constructor for the location
  Location({required this.longitude, required this.latitude});

  /// Converts a JSON object to a location
  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(longitude: json['longitude'], latitude: json['latitude']);

  /// Creates a JSON representation of the location
  Map<String, dynamic> toJson() =>
      {'longitude': longitude.toString(), 'latitude': latitude.toString()};

  /// Compares the distance between two locations and returns a double
  double distanceTo(Location other) =>
      Geolocator.distanceBetween(
          latitude, longitude, other.latitude, other.longitude) /
      1600;

  /// These are the properties to compare when determining equality
  @override
  List<Object?> get props => [longitude, latitude];
}
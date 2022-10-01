import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class Location extends Equatable {
  final double longitude, latitude;

  Location({required this.longitude, required this.latitude});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
      longitude: json['coordinates'][0], latitude: json['coordinates'][1]);

  Map<String, dynamic> toJson() =>
      {'longitude': longitude.toString(), 'latitude': latitude.toString()};

  double distanceTo(Location other) =>
      Geolocator.distanceBetween(
          latitude, longitude, other.latitude, other.longitude) /
      1600;

  @override
  List<Object?> get props => [longitude, latitude];
}

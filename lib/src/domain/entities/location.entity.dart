import 'package:geolocator/geolocator.dart';

import 'entity.dart';

class LocationEntity extends Entity<LocationEntity> {
  static const kEmpty = LocationEntity(longitude: 0, latitude: 0);

  final double longitude;
  final double latitude;

  const LocationEntity({
    required this.longitude,
    required this.latitude,
  }) : super();

  @override
  LocationEntity fromJson(Map<String, dynamic> json) => LocationEntity(
        longitude: json['coordinates'][0],
        latitude: json['coordinates'][1],
      );

  @override
  Map<String, dynamic> toJson() => {
        'type': "Point",
        'coordinates': [longitude.toString(), latitude.toString()]
      };

  double distanceTo(LocationEntity other) =>
      Geolocator.distanceBetween(
        latitude,
        longitude,
        other.latitude,
        other.longitude,
      ) /
      1600;

  @override
  List<Object?> get props => [longitude, latitude];
}

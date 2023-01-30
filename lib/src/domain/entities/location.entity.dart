import 'package:geolocator/geolocator.dart';

import '../../common/utils/utils.dart';
import 'entities.dart';

class LocationParser extends Parser<LocationEntity> {
  const LocationParser() : super();

  @override
  LocationEntity fromJson(Map<String, dynamic> json) => LocationEntity(
        longitude: json['coordinates'][0],
        latitude: json['coordinates'][1],
      );
}

class LocationEntity extends Entity {
  final double longitude;
  final double latitude;

  const LocationEntity({
    required this.longitude,
    required this.latitude,
  }) : super();

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

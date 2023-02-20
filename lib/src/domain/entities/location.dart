import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../common/utils/utils.dart';

class LocationEntity extends Equatable with Serializable {
  final double longitude;
  final double latitude;

  const LocationEntity({
    required this.longitude,
    required this.latitude,
  }) : super();

  @override
  factory LocationEntity.fromJson(Map<String, dynamic> json) => LocationEntity(
        longitude: json['coordinates'][0],
        latitude: json['coordinates'][1],
      );

  @override
  Map<String, dynamic> toJson() => {
        'type': 'Point',
        'coordinates': [longitude, latitude],
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
  List<Object> get props => [longitude, latitude];
}

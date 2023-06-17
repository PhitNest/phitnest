import 'package:equatable/equatable.dart';

class GymEntryFormSuccess extends Equatable {
  final String gymId;
  final ({double latitude, double longitude}) location;

  const GymEntryFormSuccess({
    required this.gymId,
    required this.location,
  }) : super();

  @override
  List<Object?> get props => [gymId, location];

  factory GymEntryFormSuccess.fromJson(dynamic json) => switch (json) {
        {
          'gymId': final String gymId,
          'location': final location,
        } =>
          switch (location) {
            {
              'latitude': final double latitude,
              'longitude': final double longitude
            } =>
              GymEntryFormSuccess(
                gymId: gymId,
                location: (
                  latitude: latitude,
                  longitude: longitude,
                ),
              ),
            _ => throw FormatException('Invalid JSON for location', location),
          },
        _ =>
          throw FormatException('Invalid JSON for GymEntryFormSuccess', json),
      };
}

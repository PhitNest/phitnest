import 'failures.dart';

enum LocationFailureType { permissionDenied, permissionPermenantlyDenied }

class LocationFailure extends Failure {
  final LocationFailureType type;

  const LocationFailure(this.type)
      : super(
            message: type == LocationFailureType.permissionDenied
                ? "Location permission denied"
                : "Location permission permenantly denied");
}

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';

class LocationRepository implements ILocationRepository {
  LocationEntity _positionToLocation(Position position) => LocationEntity(
      longitude: position.longitude, latitude: position.latitude);

  Future<Either<LocationEntity, Failure>> getLocation() async {
    LocationPermission permission;

    if (!await Geolocator.isLocationServiceEnabled()) {
      return Right(
        Failure("Location permissions are denied."),
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Right(
          Failure("Location permissions are denied."),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Right(
        Failure(
            "Location permissions are permanently denied, we cannot request permissions."),
      );
    }

    return Left(
      _positionToLocation(
        await Geolocator.getCurrentPosition(),
      ),
    );
  }
}

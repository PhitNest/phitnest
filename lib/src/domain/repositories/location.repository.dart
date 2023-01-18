import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../common/failure.dart';
import '../entities/entities.dart';

final locationFailure =
    Failure("LocationDenied", "Location permissions are denied.");

final locationPermenantlyDeniedFailure = Failure("LocationPermenantlyDenied",
    "Location permissions are permanently denied, we cannot request permissions.");

class LocationRepository {
  LocationEntity _positionToLocation(Position position) => LocationEntity(
      longitude: position.longitude, latitude: position.latitude);

  Future<Either<LocationEntity, Failure>> getLocation() async {
    LocationPermission permission;

    if (!await Geolocator.isLocationServiceEnabled()) {
      return Right(locationFailure);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Right(locationFailure);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Right(locationPermenantlyDeniedFailure);
    }

    return Left(
      _positionToLocation(
        await Geolocator.getCurrentPosition(),
      ),
    );
  }
}

final locationRepository = LocationRepository();

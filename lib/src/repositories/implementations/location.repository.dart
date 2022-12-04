import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../entities/entities.dart';
import '../../failures/failures.dart';
import '../interfaces/interfaces.dart';

class LocationRepository implements ILocationRepository {
  LocationEntity _positionToLocation(Position position) => LocationEntity(
      longitude: position.longitude, latitude: position.latitude);

  Future<Either<LocationEntity, LocationFailure>> getLocation() async {
    LocationPermission permission;

    if (!await Geolocator.isLocationServiceEnabled()) {
      return Right(LocationFailure(LocationFailureType.permissionDenied));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Right(LocationFailure(LocationFailureType.permissionDenied));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Right(
          LocationFailure(LocationFailureType.permissionPermenantlyDenied));
    }

    return Left(_positionToLocation(await Geolocator.getCurrentPosition()));
  }
}

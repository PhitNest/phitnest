part of utils;

LocationEntity _positionToLocation(Position position) => LocationEntity(
      longitude: position.longitude,
      latitude: position.latitude,
    );

Future<Either<LocationEntity, Failure>> getLocation() async {
  LocationPermission permission;

  if (!await Geolocator.isLocationServiceEnabled()) {
    return Right(Failures.locationFailure.instance);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Right(Failures.locationFailure.instance);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Right(Failures.locationPermanentlyDeniedFailure.instance);
  }

  return Left(
    _positionToLocation(
      await Geolocator.getCurrentPosition(),
    ),
  );
}
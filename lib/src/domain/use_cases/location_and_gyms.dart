part of use_cases;

typedef LocationAndGymsResponse
    = Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>;

Future<LocationAndGymsResponse> _getNearbyGyms() => getLocation().then(
      (either) => either.fold(
        (location) => Backend.gyms
            .nearest(
              location: location,
              meters: 30000000,
            )
            .then(
              (either) => either.leftMap(
                (list) => Tuple2(list, location),
              ),
            ),
        (failure) => Right(failure),
      ),
    );

import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/geolocator/geolocator.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

typedef LocationAndGymsResponse
    = Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>;

Future<LocationAndGymsResponse> loadGyms() => getLocation().then(
      (either) => either.fold(
        (location) => GymRepository.getNearest(location, 30000000).then(
          (either) => either.leftMap(
            (list) => Tuple2(list, location),
          ),
        ),
        (failure) => Right(failure),
      ),
    );

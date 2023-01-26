import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';

export 'cache.dart';

abstract class GymDataSource {
  static Future<Either<List<GymEntity>, Failure>> getNearest(
    LocationEntity location,
    double meters, {
    int? amount,
  }) =>
      httpAdapter.request(
        Routes.nearestGyms.instance,
        data: {
          "meters": meters.toString(),
          "latitude": location.latitude.toString(),
          "longitude": location.longitude.toString(),
          ...(amount != null ? {"amount": amount.toString()} : {}),
        },
      ).then(
        (res) => res.fold(
          (response) => response.fold(
            (json) => Right(Failures.invalidBackendResponse.instance),
            (list) =>
                Left(list.map((json) => GymEntity.fromJson(json)).toList()),
          ),
          (failure) => Right(failure),
        ),
      );
}

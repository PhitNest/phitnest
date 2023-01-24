import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../../common/failures.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';
import '../../adapters/interfaces/http.adapter.dart';
import 'backend.dart';

class GymBackend {
  const GymBackend();

  Future<Either<List<GymEntity>, Failure>> getNearest(
          LocationEntity location, double meters,
          {int? amount}) =>
      httpAdapter.request(
        HttpMethod.get,
        Routes.nearestGyms.path,
        data: {
          "meters": meters.toString(),
          "latitude": location.latitude.toString(),
          "longitude": location.longitude.toString(),
          ...(amount != null ? {"amount": amount.toString()} : {}),
        },
      ).then(
        (res) => res.fold(
          (response) => response.fold(
            (json) => Right(kInvalidBackendResponse),
            (list) => list.length > 0
                ? Left(
                    list.map((json) => GymEntity.fromJson(json)).toList(),
                  )
                : Right(
                    kNoGymsFound,
                  ),
          ),
          (failure) => Right(failure),
        ),
      );
}

const gymBackend = GymBackend();

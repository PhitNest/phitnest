import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';
import '../../adapters/interfaces/http.adapter.dart';

class GymBackend {
  const GymBackend();

  Future<Either<List<GymEntity>, Failure>> getNearest(
          LocationEntity location, double meters,
          {int? amount}) =>
      httpAdapter.request(
        HttpMethod.get,
        '/gym/nearest',
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
                    Failure("NoGymsFound", "No nearby gyms found."),
                  ),
          ),
          (failure) => Right(failure),
        ),
      );
}

const gymBackend = GymBackend();

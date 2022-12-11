import 'dart:convert';
import 'package:dartz/dartz.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../../services/services.dart';
import '../repositories.dart';

class GymRepository implements IGymRepository {
  Future<Either<List<GymEntity>, Failure>> getNearestGyms({
    required LocationEntity location,
    required double distance,
    int? amount,
  }) =>
      restService.get(
        kNearestGymsRoute,
        params: {
          "longitude": location.longitude.toString(),
          "latitude": location.latitude.toString(),
          "distance": (distance * 1600).toString(),
          ...(amount != null ? {"amount": amount.toString()} : {}),
        },
      ).then(
        (either) => either.fold(
          (response) {
            if (response.statusCode == kStatusOK) {
              final body = jsonDecode(response.body);
              if (body is List) {
                return Left(
                  body
                      .map(
                        (gym) => GymEntity.fromJson(gym),
                      )
                      .toList(),
                );
              }
            }
            return Right(
              Failure(jsonDecode(response.body).toString()),
            );
          },
          (failure) => Right(failure),
        ),
      );

  @override
  Future<Either<GymEntity, Failure>> getGym(String accessToken) => restService
      .get(
        kGym,
        accessToken: accessToken,
      )
      .then(
        (either) => either.fold(
          (response) {
            if (response.statusCode == kStatusOK) {
              return Left(
                GymEntity.fromJson(
                  jsonDecode(response.body),
                ),
              );
            } else {
              return Right(
                Failure(jsonDecode(response.body).toString()),
              );
            }
          },
          (failure) => Right(failure),
        ),
      );
}

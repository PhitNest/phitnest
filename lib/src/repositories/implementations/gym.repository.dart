import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../common/utils.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../repositories.dart';

class GymRepository implements IGymRepository {
  Future<Either<List<GymEntity>, Failure>> getNearestGyms({
    required LocationEntity location,
    required double distance,
    int? amount,
  }) async {
    try {
      return await http
          .get(
            getBackendAddress(
              kNearestGymsRoute,
              params: {
                "longitude": location.longitude.toString(),
                "latitude": location.latitude.toString(),
                "distance": (distance * 1600).toString(),
                ...(amount != null ? {"amount": amount.toString()} : {}),
              },
            ),
          )
          .timeout(
            const Duration(
              seconds: 25,
            ),
          )
          .then(
            (response) => Left(
              List<GymEntity>.from(
                jsonDecode(
                  response.body,
                ).map(
                  (gym) => GymEntity.fromJson(gym),
                ),
              ),
            ),
          );
    } catch (error) {
      return Right(
        Failure(
          type: FailureType.network,
        ),
      );
    }
  }
}

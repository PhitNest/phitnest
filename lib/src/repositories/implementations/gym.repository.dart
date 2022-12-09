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
          .timeout(requestTimeout)
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
        Failure("Failed to connect to the network."),
      );
    }
  }

  @override
  Future<Either<GymEntity, Failure>> getGym(String accessToken) => http.get(
        getBackendAddress(kGym),
        headers: {
          "authorization": "Bearer $accessToken",
        },
      ).then(
        (response) {
          if (response.statusCode == kStatusOK) {
            return Left(
              GymEntity.fromJson(
                jsonDecode(response.body),
              ),
            );
          } else {
            return Right(
              Failure("Failed to get gym."),
            );
          }
        },
      );
}

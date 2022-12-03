import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../repositories.dart';
import 'implementations.dart';

/// Handles making requests to the backend involving gyms
class GymRepository implements IGymRepository {
  Future<Either<List<GymEntity>, String>> getNearestGyms(
          {required LocationEntity location,
          required int distance,
          int? amount}) =>
      http
          .get(
            repositories<EnvironmentRepository>()
                .getBackendAddress(kNearestGymsRoute, params: {
              "longitude": location.longitude.toString(),
              "latitude": location.latitude.toString(),
              "distance": (distance * 1600).toString(),
              ...(amount != null ? {"amount": amount.toString()} : {}),
            }),
          )
          .then((response) => response.statusCode == kStatusOK
              ? Left(List<GymEntity>.from(jsonDecode(response.body)
                  .map((gym) => GymEntity.fromJson(gym))))
              : Right(response.body));
}

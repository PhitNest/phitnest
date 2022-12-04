import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/utils.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../repositories.dart';

/// Handles making requests to the backend involving gyms
class GymRepository implements IGymRepository {
  Future<List<GymEntity>> getNearestGyms({
    required LocationEntity location,
    required int distance,
    int? amount,
  }) =>
      http
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
          .then(
            (response) => List<GymEntity>.from(
              jsonDecode(
                response.body,
              ).map(
                (gym) => GymEntity.fromJson(gym),
              ),
            ),
          );
}

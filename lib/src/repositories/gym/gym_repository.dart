import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../repositories.dart';

/// Handles making requests to the backend involving gyms
class GymRepository {
  /// The distance in miles to search for gyms
  static const double kGymSearchRadiusMiles = 30000;

  /// Gets all gyms within [kGymSearchRadiusMiles].
  Future<List<Gym>> getNearestGyms({required Location location, int? amount}) =>
      http
          .get(
            repositories<EnvironmentRepository>()
                .getBackendAddress(kNearestGymsRoute, params: {
              "longitude": location.longitude.toString(),
              "latitude": location.latitude.toString(),
              "distance": (kGymSearchRadiusMiles * 1600).toString(),
              ...(amount != null ? {"amount": amount.toString()} : {}),
            }),
          )
          .then((response) => response.statusCode == kStatusOK
              ? List<Gym>.from(
                  jsonDecode(response.body).map((gym) => Gym.fromJson(gym)))
              : []);
}

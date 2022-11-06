import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../repositories.dart';

/// Handles making requests to the backend involving gyms
class GymRepository extends Repository {
  /// This is the currently selected gym. If you are logged in, this will be
  /// the gym you are registered with. If you are not logged in, this will be
  /// the gym you select on the gym search screen.
  Gym? _currentlySelectedGym;

  /// Gets the currently selected gym
  Gym? get currentlySelectedGym => _currentlySelectedGym;

  /// Updates the currently selected gym
  set currentlySelectedGym(Gym? currentlySelectedGym) =>
      _currentlySelectedGym = currentlySelectedGym;

  /// The distance in miles to search for gyms
  static const double kGymSearchRadiusMiles = 30000;

  /// Gets the nearest gym to a location within [kGymSearchRadiusMiles]
  Future<Gym?> getNearestGym(Location location) => http
      .get(
        repositories<EnvironmentRepository>()
            .getBackendAddress(kNearestGymRoute, params: {
          ...location.toJson(),
          "distance": "$kGymSearchRadiusMiles"
        }),
      )
      .then((response) => response.statusCode == kStatusOK
          ? Gym.fromJson(jsonDecode(response.body))
          : null);

  /// Gets all gyms within [kGymSearchRadiusMiles].
  Future<List<Gym>> getNearestGyms(Location location) => http
      .get(
        repositories<EnvironmentRepository>().getBackendAddress(kListGymsRoute,
            params: {
              ...location.toJson(),
              "distance": "$kGymSearchRadiusMiles"
            }),
      )
      .then((response) => response.statusCode == kStatusOK
          ? List<Gym>.from(
              jsonDecode(response.body).map((gym) => Gym.fromJson(gym)))
          : []);
}

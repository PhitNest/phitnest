import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../repositories.dart';

class LocationRepository extends Repository {
  Future<Gym?> getNearestGym(Location location) => http
      .get(
        repositories<EnvironmentRepository>().getBackendAddress(
            kNearestGymRoute,
            params: {...location.toJson(), "distance": "30000"}),
      )
      .then((response) => response.statusCode == kStatusOK
          ? Gym.fromJson(jsonDecode(response.body))
          : null);

  Future<List<Gym>> getNearestGyms(Location location) => http
      .get(
        repositories<EnvironmentRepository>().getBackendAddress(kListGymsRoute,
            params: {...location.toJson(), "distance": "30000"}),
      )
      .then((response) => response.statusCode == kStatusOK
          ? List<Gym>.from(
              jsonDecode(response.body).map((gym) => Gym.fromJson(gym)))
          : []);

  Stream<ServiceStatus> streamServiceStatus() =>
      Geolocator.getServiceStatusStream();

  Location _positionToLocation(Position position) =>
      Location(longitude: position.longitude, latitude: position.latitude);

  /// Will either return a valid user location as a [Location], or
  /// return a [String] if there is an error.
  Future<Either<Location, String>> getLocation() async {
    LocationPermission permission;

    // Test if location services are enabled.
    if (!await Geolocator.isLocationServiceEnabled()) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Right('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Right('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Right(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return Left(_positionToLocation(await Geolocator.getCurrentPosition()));
  }
}
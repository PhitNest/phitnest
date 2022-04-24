import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:phitnest/models/user/user_model.dart';

class LocationUtils {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.'.tr());
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
        return Future.error('Location permissions are denied'.tr());
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.'
              .tr());
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
          // This line breaks android emulator
          // forceAndroidLocationManager: true,
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      print('getCurrentLocation $e');
    }
    return position;
  }

  static bool isInPreferredDistance(UserModel user, double distance) {
    if (user.settings.distanceRadius.isNotEmpty) {
      if (distance <= (int.tryParse(user.settings.distanceRadius) ?? 0)) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  static double getDistance(
      UserLocation userLocation, UserLocation myLocation) {
    final Distance distance = Distance();
    final double milesAway = distance
        .as(
            LengthUnit.Mile,
            LatLng(userLocation.latitude, userLocation.longitude),
            LatLng(myLocation.latitude, myLocation.longitude))
        .toDouble();
    return milesAway;
  }
}

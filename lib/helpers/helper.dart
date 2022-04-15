import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:phitnest/constants.dart';
import 'package:phitnest/main.dart';
import 'package:phitnest/model/user.dart' as user;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => destination));
}

push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}

pushAndRemoveUntil(BuildContext context, Widget destination, bool predict) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (Route<dynamic> route) => predict);
}

String formatTimestamp(int timestamp) {
  var format = DateFormat('hh:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return format.format(date);
}

String setLastSeen(int seconds) {
  var format = DateFormat('hh:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  var diff = DateTime.now().millisecondsSinceEpoch - (seconds * 1000);
  if (diff < 24 * HOUR_MILLIS) {
    return format.format(date);
  } else if (diff < 48 * HOUR_MILLIS) {
    return 'Yesterday at ${format.format(date)}'.tr();
  } else {
    format = DateFormat('MMM d');
    return '${format.format(date)}';
  }
}

Widget displayCircleImage(String picUrl, double size, hasBorder) =>
    CachedNetworkImage(
        imageBuilder: (context, imageProvider) =>
            _getCircularImageProvider(imageProvider, size, false),
        imageUrl: picUrl,
        placeholder: (context, url) =>
            _getPlaceholderOrErrorImage(size, hasBorder),
        errorWidget: (context, url, error) =>
            _getPlaceholderOrErrorImage(size, hasBorder));

Widget _getPlaceholderOrErrorImage(double size, hasBorder) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
        border: Border.all(
          color: Colors.white,
          width: hasBorder ? 2.0 : 0.0,
        ),
      ),
      child: ClipOval(
          child: Image.asset(
        'assets/images/placeholder.jpg',
        fit: BoxFit.cover,
        height: size,
        width: size,
      )),
    );

Widget _getCircularImageProvider(
    ImageProvider provider, double size, bool hasBorder) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xff7c94b6),
      borderRadius: BorderRadius.all(Radius.circular(size / 2)),
      border: Border.all(
        color: Colors.white,
        width: hasBorder ? 2.0 : 0.0,
      ),
    ),
    child: ClipOval(
        child: FadeInImage(
            fit: BoxFit.cover,
            placeholder: Image.asset(
              'assets/images/placeholder.jpg',
              fit: BoxFit.cover,
              height: size,
              width: size,
            ).image,
            image: provider)),
  );
}

bool isDarkMode(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.light) {
    return false;
  } else {
    return true;
  }
}

Future<Position?> getCurrentLocation() async {
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

bool isInPreferredDistance(double distance) {
  if (PhitnestApp.currentUser!.settings.distanceRadius.isNotEmpty) {
    if (distance <=
        (int.tryParse(PhitnestApp.currentUser!.settings.distanceRadius) ?? 0)) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

bool isPreferredGender(String gender) {
  if (PhitnestApp.currentUser!.settings.genderPreference != 'All') {
    return gender == PhitnestApp.currentUser!.settings.genderPreference;
  } else {
    return true;
  }
}

double getDistance(
    user.UserLocation userLocation, user.UserLocation myLocation) {
  final Distance distance = Distance();
  final double milesAway = distance
      .as(
          LengthUnit.Mile,
          LatLng(userLocation.latitude, userLocation.longitude),
          LatLng(myLocation.latitude, myLocation.longitude))
      .toDouble();
  return milesAway;
}

String audioMessageTime(Duration? audioDuration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  String twoDigitsHours(int n) {
    if (n >= 10) return '$n:';
    if (n == 0) return '';
    return '0$n:';
  }

  String twoDigitMinutes =
      twoDigits(audioDuration?.inMinutes.remainder(60) ?? 0);
  String twoDigitSeconds =
      twoDigits(audioDuration?.inSeconds.remainder(60) ?? 0);
  return '${twoDigitsHours(audioDuration?.inHours ?? 0)}$twoDigitMinutes:$twoDigitSeconds';
}

String updateTime(Timer timer) {
  Duration callDuration = Duration(seconds: timer.tick);
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  String twoDigitsHours(int n) {
    if (n >= 10) return '$n:';
    if (n == 0) return '';
    return '0$n:';
  }

  String twoDigitMinutes = twoDigits(callDuration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(callDuration.inSeconds.remainder(60));
  return '${twoDigitsHours(callDuration.inHours)}$twoDigitMinutes:$twoDigitSeconds';
}

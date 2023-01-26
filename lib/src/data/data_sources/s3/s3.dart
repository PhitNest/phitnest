import 'dart:convert';

import 'package:camera/camera.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import 'package:http/http.dart' as http;

import '../../../common/logger.dart';

Future<Failure?> uploadPhoto(String uploadUrl, XFile photo) async => http
        .put(
      Uri.parse(uploadUrl),
      headers: {
        'Content-Type': 'image/*',
        'Accept': "*/*",
        'Content-Length': (await photo.length()).toString(),
        'Connection': 'keep-alive',
      },
      body: await photo.readAsBytes(),
    )
        .then(
      (res) {
        if (res.statusCode == kStatusOK) {
          prettyLogger.d("Successfully sent profile picture to S3");
          return null;
        } else {
          prettyLogger.e("Failed to send profile picture to S3");
          return Failure.fromJson(
            jsonDecode(res.body),
          );
        }
      },
    );

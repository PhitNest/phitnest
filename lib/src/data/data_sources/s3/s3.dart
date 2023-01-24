import 'dart:convert';

import 'package:camera/camera.dart';

import '../../../common/failure.dart';
import 'package:http/http.dart' as http;

class PhotoDatabase {
  const PhotoDatabase();

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
        (res) => res.statusCode == 200
            ? null
            : Failure.fromJson(
                jsonDecode(res.body),
              ),
      );
}

const photoDatabase = const PhotoDatabase();

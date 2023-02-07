import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart' as editor;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constants/constants.dart';
import '../failure.dart';
import '../logger.dart';

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

extension TakeProfilePicture on CameraController {
  Future<XFile> takeProfilePicture() => takePicture().then(
        (file) => file.centerCrop(),
      );
}

extension Crop on XFile {
  Future<XFile> centerCrop() async {
    final inBytes = await readAsBytes();
    final inImage = await decodeImageFromList(inBytes);
    final width = inImage.width;
    final height = inImage.height;
    final scaledHeight = height * 0.75;
    final imageEditOptions = editor.ImageEditorOption()
      ..addOption(
        editor.ClipOption(
          width: width,
          height: scaledHeight,
          y: height / 2 - scaledHeight / 2,
        ),
      );
    final outBytes = await editor.ImageEditor.editImage(
      image: inBytes,
      imageEditorOption: imageEditOptions,
    );
    if (outBytes == null) {
      throw CameraException(
        Failures.failedToCropImage.code,
        Failures.failedToCropImage.message,
      );
    }
    return XFile.fromData(
      outBytes,
      name: name,
      path: path,
      mimeType: mimeType,
    );
  }
}

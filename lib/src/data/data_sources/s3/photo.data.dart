import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

import '../../../common/failure.dart';
import 'package:http/http.dart' as http;

import '../../../common/failures.dart';

class PhotoDatabase {
  const PhotoDatabase();

  Future<XFile> centerCrop(XFile photo) async {
    final inBytes = await photo.readAsBytes();
    final inImage = await decodeImageFromList(inBytes);
    final width = inImage.width;
    final height = inImage.height;
    final scaledHeight = height / 1.777777;
    final imageEditOptions = ImageEditorOption()
      ..addOption(
        ClipOption(
          width: width,
          height: scaledHeight,
          y: height / 2 - scaledHeight / 2,
        ),
      );
    final outBytes = await ImageEditor.editImage(
      image: inBytes,
      imageEditorOption: imageEditOptions,
    );
    if (outBytes == null) {
      throw CameraException(
          kFailedToCropImage.code, kFailedToCropImage.message);
    }
    return XFile.fromData(
      outBytes,
      name: photo.name,
      path: photo.path,
      mimeType: photo.mimeType,
    );
  }

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

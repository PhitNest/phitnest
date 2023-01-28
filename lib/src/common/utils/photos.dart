import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

import '../constants/failures.dart';

extension Crop on XFile {
  Future<XFile> centerCrop(double heightFactor) async {
    final inBytes = await readAsBytes();
    final inImage = await decodeImageFromList(inBytes);
    final width = inImage.width;
    final height = inImage.height;
    final scaledHeight = height * heightFactor;
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

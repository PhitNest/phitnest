import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

import 'constants/failures.dart';

extension FormatQuantity on double {
  /// This will return a rounded string version of this [double] with [unit]
  /// appended as the units of measurement.
  ///
  /// Examples:    1.2.formatQuantity('mile') == '1.2 miles'
  ///              1.273532.formatQuantity('inch') == '1.3 inchs'
  ///              1.0.formatQuantity('meter') == '1 meter'
  ///              2.0.formatQuantity('cm') == '2 cms'
  String formatQuantity(String unit) =>
      '${this.floor().toDouble() == this ? this.floor() : this.toStringAsFixed(1)} $unit${this == 1 ? '' : 's'}';
}

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

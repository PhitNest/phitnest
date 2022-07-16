import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker imagePicker = ImagePicker();

Future<File?> retrieveLostData() async {
  final LostDataResponse? response = await imagePicker.retrieveLostData();
  if (response == null) {
    return null;
  }
  if (response.file != null) {
    return File(response.file!.path);
  }

  return null;
}

selectPhoto(
    BuildContext context, String message, Function(File? photo) onSelect) {
  final action = CupertinoActionSheet(
    message: Text(
      message,
      style: TextStyle(fontSize: 15.0),
    ),
    actions: <Widget>[
      CupertinoActionSheetAction(
        child: Text('Choose from gallery'),
        isDefaultAction: false,
        onPressed: () async {
          Navigator.pop(context);
          XFile? file =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (file != null) {
            onSelect(File(file.path));
          }
        },
      ),
      CupertinoActionSheetAction(
        child: Text('Take a picture'),
        isDestructiveAction: false,
        onPressed: () async {
          Navigator.pop(context);
          XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
          if (file != null) {
            onSelect(File(file.path));
          }
        },
      )
    ],
    cancelButton: CupertinoActionSheetAction(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );

  showCupertinoModalPopup(context: context, builder: (context) => action);
}

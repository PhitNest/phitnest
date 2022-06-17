import 'dart:io';

import 'package:device/device.dart';
import 'package:flutter/material.dart';

import '../profile_picture.dart';

/// This will allow you to select a photo from native camera for profile picture
class ProfilePictureSelector extends ProfilePictureWidget {
  ProfilePictureSelector({
    required Key key,
    required Image image,
    required Function(File? selectedImage) onSelected,
    EdgeInsets padding = EdgeInsets.zero,
    double scale = 1.0,
  }) : super(
          key: key,
          image: image,
          tapImage: (context) =>
              selectPhoto(context, 'Select Profile Picture', onSelected),
          scale: scale,
          padding: padding,
          icon: Icon(
            Icons.camera_alt,
            color: Colors.black,
          ),
        );
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device/device.dart';
import 'package:flutter/material.dart';

import '../profile_picture.dart';

/// This will allow you to select a photo from native camera for profile picture
class ProfilePictureSelector extends ProfilePictureWidget {
  ProfilePictureSelector._({
    required Key key,
    required Widget image,
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

  factory ProfilePictureSelector.fromNetwork(
    String url, {
    required Key key,
    required Function(File? selectedImage) onSelected,
    EdgeInsets padding = EdgeInsets.zero,
    double scale = 1.0,
  }) =>
      ProfilePictureSelector._(
        key: key,
        image: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, provider) => Image(
            image: provider,
            fit: BoxFit.cover,
          ),
        ),
        onSelected: onSelected,
        padding: padding,
        scale: scale,
      );

  factory ProfilePictureSelector.fromFile(
    File file, {
    required Key key,
    required Function(File? selectedImage) onSelected,
    EdgeInsets padding = EdgeInsets.zero,
    double scale = 1.0,
  }) =>
      ProfilePictureSelector._(
        key: key,
        image: Image.file(
          file,
          fit: BoxFit.cover,
        ),
        onSelected: onSelected,
        padding: padding,
        scale: scale,
      );
}

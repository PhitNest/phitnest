import 'dart:io';

import 'package:flutter/material.dart';

import '../profile_picture.dart';

/// This will allow you to select a photo from native camera for profile picture
class ProfilePictureChatStatus extends ProfilePictureWidget {
  /// Shows a profile picture with circle indicating activity status.
  ProfilePictureChatStatus({
    required Key key,
    required Image image,
    required bool online,
    Function(BuildContext context)? tapImage,
    Function(BuildContext context)? tapIcon,
    EdgeInsets padding = EdgeInsets.zero,
    double scale = 1.0,
  }) : super(
          key: key,
          image: image,
          tapImage: tapImage,
          tapIcon: tapIcon,
          scale: scale,
          padding: padding,
          iconBackgroundColor: online ? Colors.green : Colors.grey,
        );

  factory ProfilePictureChatStatus.fromNetwork(
    String url, {
    required Key key,
    required bool online,
    Function(BuildContext context)? tapImage,
    Function(BuildContext context)? tapIcon,
    EdgeInsets padding = EdgeInsets.zero,
    double scale = 1.0,
  }) =>
      ProfilePictureChatStatus(
        key: key,
        image: Image.network(
          url,
          fit: BoxFit.cover,
        ),
        online: online,
        tapIcon: tapIcon,
        tapImage: tapImage,
        padding: padding,
        scale: scale,
      );

  factory ProfilePictureChatStatus.fromFile(
    File file, {
    required Key key,
    required bool online,
    Function(BuildContext context)? tapImage,
    Function(BuildContext context)? tapIcon,
    EdgeInsets padding = EdgeInsets.zero,
    double scale = 1.0,
  }) =>
      ProfilePictureChatStatus(
        key: key,
        image: Image.file(
          file,
          fit: BoxFit.cover,
        ),
        online: online,
        tapIcon: tapIcon,
        tapImage: tapImage,
        padding: padding,
        scale: scale,
      );
}

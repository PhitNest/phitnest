import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../profile_picture.dart';

/// This will allow you to select a photo from native camera for profile picture
class ProfilePictureChatStatus extends ProfilePictureWidget {
  /// Shows a profile picture with circle indicating activity status.
  ProfilePictureChatStatus._({
    required Key key,
    required Widget image,
    required bool online,
    bool showStatus = true,
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
          showIcon: showStatus,
          padding: padding,
          iconBackgroundColor: online ? Colors.green : Colors.grey,
        );

  factory ProfilePictureChatStatus.fromNetwork(
    String url, {
    required Key key,
    required bool online,
    bool showStatus = true,
    Function(BuildContext context)? tapImage,
    Function(BuildContext context)? tapIcon,
    EdgeInsets padding = EdgeInsets.zero,
    double scale = 1.0,
  }) =>
      ProfilePictureChatStatus._(
        key: key,
        image: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, provider) => Image(
            image: provider,
            fit: BoxFit.cover,
          ),
        ),
        online: online,
        showStatus: showStatus,
        tapIcon: tapIcon,
        tapImage: tapImage,
        padding: padding,
        scale: scale,
      );

  factory ProfilePictureChatStatus.fromFile(
    File file, {
    required Key key,
    required bool online,
    bool showStatus = true,
    Function(BuildContext context)? tapImage,
    Function(BuildContext context)? tapIcon,
    EdgeInsets padding = EdgeInsets.zero,
    double scale = 1.0,
  }) =>
      ProfilePictureChatStatus._(
        key: key,
        image: Image.file(
          file,
          fit: BoxFit.cover,
        ),
        online: online,
        tapIcon: tapIcon,
        showStatus: showStatus,
        tapImage: tapImage,
        padding: padding,
        scale: scale,
      );
}

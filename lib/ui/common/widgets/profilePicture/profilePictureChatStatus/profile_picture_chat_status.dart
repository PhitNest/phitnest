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
}

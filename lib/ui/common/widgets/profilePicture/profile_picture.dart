export 'profilePictureChatStatus/profile_picture_chat_status.dart';
export 'profilePictureSelector/profile_picture_selector_widget.dart';

import 'package:flutter/material.dart';

/// This will show a profile picture in a circle with a given icon in the corner.
class ProfilePictureWidget extends StatelessWidget {
  static const double BASE_WIDTH = 130;

  final Image image;

  final bool showIcon;

  /// Icon to show in the bottom right corner
  final Widget? icon;

  final double scale;

  /// This is called when the image is tapped
  final Function(BuildContext context)? tapImage;

  /// This is called when the icon is tapped
  final Function(BuildContext context)? tapIcon;

  final Color? iconBackgroundColor;

  final EdgeInsets padding;

  const ProfilePictureWidget({
    required Key key,
    required this.image,
    this.showIcon = true,
    this.icon,
    this.scale = 1.0,
    this.padding = EdgeInsets.zero,
    this.tapImage,
    this.tapIcon,
    this.iconBackgroundColor,
  }) : super();

  @override
  Widget build(BuildContext context) => Container(
      constraints: BoxConstraints(maxWidth: BASE_WIDTH * scale),
      padding: padding,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            child: CircleAvatar(
              radius: BASE_WIDTH * scale / 2,
              backgroundColor: Colors.grey.shade400,
              child: ClipOval(
                  child: SizedBox(
                      width: BASE_WIDTH * scale,
                      height: BASE_WIDTH * scale,
                      child: image)),
            ),
            onTap: () => tapImage != null ? tapImage!(context) : {},
          ),
          Visibility(
            visible: showIcon,
            child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  key: key,
                  child: CircleAvatar(
                    radius: BASE_WIDTH * scale / 6,
                    backgroundColor: iconBackgroundColor,
                    child: icon,
                  ),
                  onTap: () => tapIcon != null
                      ? tapIcon!(context)
                      : tapImage != null
                          ? tapImage!(context)
                          : {},
                )),
          )
        ],
      ));
}

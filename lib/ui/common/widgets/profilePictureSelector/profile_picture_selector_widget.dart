import 'dart:io';

import 'package:device/device.dart';
import 'package:flutter/material.dart';

/// This will allow you to select a photo from native camera for profile picture
class ProfilePictureSelector extends StatelessWidget {
  final Image initialImage;

  /// Whether or not to show the selector button
  final bool showButton;

  final double scale;

  /// This is called when the image is tapped
  final Function()? tapImage;

  /// This is called when the image is selected
  final Function(File? selectedImage) onSelected;

  const ProfilePictureSelector(
      {required Key key,
      required this.onSelected,
      required this.initialImage,
      this.scale = 1.0,
      this.tapImage,
      this.showButton = true})
      : super();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GestureDetector(
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey.shade400,
            child: ClipOval(
                child: SizedBox(
                    width: 170 * scale,
                    height: 170 * scale,
                    child: initialImage)),
          ),
          onTap: () =>
              tapImage ??
              selectPhoto(context, 'Select Profile Picture', onSelected),
        ),
        Visibility(
            visible: showButton,
            child: Positioned(
                left: 80,
                right: 0,
                child: FloatingActionButton(
                  key: key,
                  backgroundColor: accentColor,
                  child: Icon(
                    Icons.camera_alt,
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                  mini: true,
                  onPressed: () => selectPhoto(
                      context, 'Select Profile Picture', onSelected),
                ))),
      ],
    );
  }
}

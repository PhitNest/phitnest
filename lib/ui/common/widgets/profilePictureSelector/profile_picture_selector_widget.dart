import 'dart:io';

import 'package:device/device.dart';
import 'package:flutter/material.dart';

/// This will allow you to select a photo from native camera for profile picture
class ProfilePictureSelector extends StatelessWidget {
  final File? initialImage;

  /// This is called when the image is selected
  final Function(File? selectedImage) onSelected;

  const ProfilePictureSelector(
      {required Key key, required this.onSelected, this.initialImage})
      : super();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        CircleAvatar(
          radius: 65,
          backgroundColor: Colors.grey.shade400,
          child: ClipOval(
            child: SizedBox(
              width: 170,
              height: 170,
              child: initialImage == null
                  ? Image.asset(
                      'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      initialImage!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        Positioned(
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
              onPressed: () =>
                  selectPhoto(context, 'Select Profile Picture', onSelected),
            )),
      ],
    );
  }
}

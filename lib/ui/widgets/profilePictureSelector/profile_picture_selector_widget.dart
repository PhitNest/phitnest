import 'dart:io';

import 'package:display/display.dart';
import 'package:flutter/material.dart';
import 'package:select_photo/select_photo.dart';

class ProfilePictureSelector extends StatelessWidget {
  final File? initialImage;
  final Function(File? selectedImage) onDone;

  const ProfilePictureSelector(
      {Key? key, required this.onDone, this.initialImage})
      : super(key: key);

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
              backgroundColor: accentColor,
              child: Icon(
                Icons.camera_alt,
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              mini: true,
              onPressed: () =>
                  selectPhoto(context, 'Select Profile Picture', onDone),
            )),
      ],
    );
  }
}

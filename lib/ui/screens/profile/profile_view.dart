import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phitnest/ui/common/textStyles/text_styles.dart';
import 'package:phitnest/ui/common/widgets/widgets.dart';

import '../screen_view.dart';

class ProfileView extends ScreenView {
  final dynamic profilePictureUrlOrFile;
  final Function(File? photo) onSelectPhoto;
  final String firstName;
  final String? lastName;

  const ProfileView(
      {Key? key,
      required this.onSelectPhoto,
      required this.profilePictureUrlOrFile,
      required this.firstName,
      required this.lastName})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'My Account',
                style: HeadingTextStyle(size: TextSize.LARGE),
              ),
              profilePictureUrlOrFile is String
                  ? ProfilePictureSelector.fromNetwork(profilePictureUrlOrFile,
                      key: Key('profile_photoSelector'),
                      onSelected: onSelectPhoto)
                  : ProfilePictureSelector.fromFile(profilePictureUrlOrFile,
                      key: Key('profile_photoSelector'),
                      onSelected: onSelectPhoto)
            ],
          )));
}

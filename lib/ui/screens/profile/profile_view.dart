import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phitnest/ui/common/textStyles/text_styles.dart';
import 'package:phitnest/ui/common/widgets/widgets.dart';

import '../views.dart';

class ProfileView extends BaseView {
  final Function(File? photo) onSelectPhoto;
  final Image? profilePicture;
  final String firstName;
  final String? lastName;

  const ProfileView(
      {Key? key,
      required this.onSelectPhoto,
      required this.profilePicture,
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
                style:
                    HeadingTextStyle(size: TextSize.LARGE, color: Colors.black),
              ),
              ProfilePictureSelector(
                  key: Key('profile_photoSelector'),
                  initialImage: profilePicture,
                  showButton: false,
                  tapImage: () {},
                  onSelected: onSelectPhoto)
            ],
          )));
}

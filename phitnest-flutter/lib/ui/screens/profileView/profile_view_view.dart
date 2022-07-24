import 'dart:io';

import 'package:flutter/material.dart';
import 'package:validation/validation.dart';

import '../../common/textStyles/text_styles.dart';
import '../../common/widgets/widgets.dart';
import '../screen_view.dart';

class ProfileViewView extends ScreenView {
  final GlobalKey<FormState> formKey;
  final dynamic profilePictureUrlOrFile;
  final Function(File? photo) onSelectPhoto;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController bioController;

  const ProfileViewView({
    Key? key,
    required this.formKey,
    required this.onSelectPhoto,
    required this.profilePictureUrlOrFile,
    required this.bioController,
    required this.firstNameController,
    required this.lastNameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: BackButtonAppBar(
        color: Colors.grey.shade300,
        content: Text(
          'View Profile',
          style: HeadingTextStyle(size: TextSize.LARGE, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfilePictureWithStatus.fromNetwork(
                        profilePictureUrlOrFile,
                        key: Key('profileView_profilePicture'),
                        showStatus: false,
                        online: true,
                      ),
                      TextField(
                        key: Key('profile_firstName'),
                        controller: firstNameController,
                        enabled: false,
                      ),
                      TextField(
                        key: Key('profile_lastName'),
                        controller: lastNameController,
                        enabled: false,
                      ),
                      TextField(
                        key: Key('profile_bio'),
                        controller: bioController,
                        enabled: false,
                      ),
                    ],
                  )))));
}

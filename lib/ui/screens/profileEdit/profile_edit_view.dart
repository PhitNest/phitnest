import 'dart:io';

import 'package:flutter/material.dart';
import 'package:validation/validation.dart';

import '../../common/textStyles/text_styles.dart';
import '../../common/widgets/widgets.dart';
import '../screen_view.dart';

class ProfileEditView extends ScreenView {
  final GlobalKey<FormState> formKey;
  final dynamic profilePictureUrlOrFile;
  final Function(File? photo) onSelectPhoto;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController bioController;
  final DateEditingController birthdayController;
  final Function() onClickSubmit;

  const ProfileEditView({
    Key? key,
    required this.formKey,
    required this.onSelectPhoto,
    required this.profilePictureUrlOrFile,
    required this.bioController,
    required this.birthdayController,
    required this.firstNameController,
    required this.lastNameController,
    required this.onClickSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: BackButtonAppBar(
        color: Colors.grey.shade300,
        content: Text(
          'Edit Profile',
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
                      profilePictureUrlOrFile is String
                          ? ProfilePictureSelector.fromNetwork(
                              profilePictureUrlOrFile,
                              key: Key('profile_photoSelector'),
                              onSelected: onSelectPhoto)
                          : ProfilePictureSelector.fromFile(
                              profilePictureUrlOrFile,
                              key: Key('profile_photoSelector'),
                              onSelected: onSelectPhoto),
                      TextInputFormField(
                          key: Key('profile_firstName'),
                          hint: 'First Name',
                          controller: firstNameController,
                          hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                          inputType: TextInputType.name,
                          validator: validateFirstName),
                      TextInputFormField(
                          key: Key('profile_lastName'),
                          hint: 'Last Name',
                          controller: lastNameController,
                          hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                          inputType: TextInputType.name,
                          validator: validateLastName),
                      TextInputFormField(
                          key: Key('profile_bio'),
                          hint: 'Bio',
                          controller: bioController,
                          hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                          inputType: TextInputType.multiline,
                          validator: validateChatMessage),
                      DateInputFormField(
                          key: Key('profile_DOB'),
                          hint: 'Date of Birth',
                          hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                          validator: validateDate,
                          controller: birthdayController),
                      StyledButton(
                          key: Key('profileEdit_button'),
                          text: 'Submit',
                          onClick: onClickSubmit),
                    ],
                  )))));
}

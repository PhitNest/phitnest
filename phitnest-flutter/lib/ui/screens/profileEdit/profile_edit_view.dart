import 'package:flutter/material.dart';
import 'package:validation/validation.dart';

import '../../common/textStyles/text_styles.dart';
import '../../common/widgets/widgets.dart';
import '../screen_view.dart';

class ProfileEditView extends ScreenView {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController bioController;
  final Function() onClickSubmit;

  const ProfileEditView({
    Key? key,
    required this.formKey,
    required this.bioController,
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
                      StyledButton(
                          key: Key('profileEdit_button'),
                          text: 'Submit',
                          onClick: onClickSubmit),
                    ],
                  )))));
}

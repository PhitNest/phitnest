import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phitnest/constants/constants.dart';

import '../../common/textStyles/text_styles.dart';
import '../../common/widgets/widgets.dart';
import '../screen_view.dart';

/// This view contains a form allowing users to sign up.
class RegisterView extends ScreenView {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final DateEditingController dateOfBirthController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final AutovalidateMode validate;
  final File? image;
  final Function() onClickSignup;
  final Function(File? image) onSaveImage;
  final String? Function(String? firstName) validateFirstName;
  final String? Function(String? lastName) validateLastName;
  final String? Function(String? email) validateEmail;
  final String? Function(String? mobile) validateMobile;
  final String? Function(String? dateOfBirth) validateDateOfBirth;
  final String? Function(String? password) validatePassword;
  final String? Function(String? confirmPassword) validateConfirmPassword;

  const RegisterView({
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.mobileController,
    required this.dateOfBirthController,
    required this.confirmPasswordController,
    required this.passwordController,
    required this.validate,
    required this.image,
    required this.onClickSignup,
    required this.onSaveImage,
    required this.validateFirstName,
    required this.validateLastName,
    required this.validateEmail,
    required this.validateMobile,
    required this.validateDateOfBirth,
    required this.validatePassword,
    required this.validateConfirmPassword,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BackButtonAppBar(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Form(
              key: formKey,
              autovalidateMode: validate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: HeadingTextStyle(size: TextSize.HUGE),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: image == null
                          ? ProfilePictureSelector.fromNetwork(
                              kDefaultAvatarUrl,
                              key: Key("register_photoSelect"),
                              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                              onSelected: onSaveImage)
                          : ProfilePictureSelector.fromFile(image!,
                              key: Key("register_photoSelect"),
                              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                              onSelected: onSaveImage)),
                  TextInputFormField(
                    key: Key("register_firstName"),
                    hint: 'First Name',
                    hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                    controller: firstNameController,
                    inputType: TextInputType.name,
                    validator: validateFirstName,
                  ),
                  TextInputFormField(
                      key: Key("register_lastName"),
                      hint: 'Last Name',
                      hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                      inputType: TextInputType.name,
                      controller: lastNameController,
                      validator: validateLastName),
                  TextInputFormField(
                      key: Key("register_email"),
                      hint: 'Email Address',
                      hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: validateEmail),
                  MobileInputFormField(
                    key: Key("register_mobile"),
                    controller: mobileController,
                    validator: validateMobile,
                    hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                  ),
                  DateInputFormField(
                    key: Key("register_dateOfBirth"),
                    hint: "Date of Birth",
                    hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                    controller: dateOfBirthController,
                    validator: validateDateOfBirth,
                  ),
                  TextInputFormField(
                    key: Key("register_password"),
                    hint: 'Password',
                    hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                    hide: true,
                    controller: passwordController,
                    validator: validatePassword,
                  ),
                  TextInputFormField(
                      key: Key("register_confirmPassword"),
                      hint: 'Confirm Password',
                      hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                      onSubmit: (_) => onClickSignup(),
                      controller: confirmPasswordController,
                      validator: validateConfirmPassword,
                      hide: true),
                  Align(
                      alignment: Alignment.center,
                      child: StyledButton(
                        key: Key("signUp_submit"),
                        text: 'Finish',
                        onClick: onClickSignup,
                        padding: EdgeInsets.all(16.0),
                      )),
                ],
              ),
            ),
          ),
        ),
      );
}

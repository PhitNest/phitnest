import 'dart:io';

import 'package:display/display.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../widgets/widgets.dart';
import '../views.dart';

/// This view contains a form allowing users to sign up.
class SignupView extends BaseView {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController passwordController;
  final AutovalidateMode validate;
  final File? image;
  final Function() onClickSignup;
  final Function(File? image) onSaveImage;
  final String? Function(String? firstName) validateFirstName;
  final String? Function(String? lastName) validateLastName;
  final String? Function(String? email) validateEmail;
  final String? Function(String? mobile) validateMobile;
  final Function(String? mobile) onSaveMobile;
  final String? Function(String? password) validatePassword;
  final String? Function(String? confirmPassword) validateConfirmPassword;

  const SignupView({
    Key? key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.mobileController,
    required this.passwordController,
    required this.validate,
    required this.image,
    required this.onClickSignup,
    required this.onSaveImage,
    required this.validateFirstName,
    required this.validateLastName,
    required this.validateEmail,
    required this.validateMobile,
    required this.onSaveMobile,
    required this.validatePassword,
    required this.validateConfirmPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BackButtonAppBar(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Form(
              key: formKey,
              autovalidateMode: validate,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Create new account',
                        style: HeadingTextStyle(size: Size.LARGE),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 8, top: 32, right: 8, bottom: 8),
                      child: ProfilePictureSelector(
                          initialImage: image, onSelected: onSaveImage)),
                  TextInputFormField(
                    hint: 'First Name',
                    controller: firstNameController,
                    inputType: TextInputType.name,
                    validator: validateFirstName,
                  ),
                  TextInputFormField(
                      hint: 'Last Name',
                      inputType: TextInputType.name,
                      controller: lastNameController,
                      validator: validateLastName),
                  TextInputFormField(
                      hint: 'Email Address',
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: validateEmail),
                  MobileInputFormField(
                      controller: mobileController,
                      validator: validateMobile,
                      onChanged: onSaveMobile),
                  TextInputFormField(
                    hint: 'Password',
                    hide: true,
                    controller: passwordController,
                    validator: validatePassword,
                  ),
                  TextInputFormField(
                      hint: 'Confirm Password',
                      onSubmit: onClickSignup,
                      validator: validateConfirmPassword,
                      hide: true),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, top: 40.0),
                    child: StyledButton(
                      text: 'Sign Up',
                      onClick: onClickSignup,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

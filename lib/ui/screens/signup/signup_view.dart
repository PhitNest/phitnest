import 'dart:io';

import 'package:display/display.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../widgets/widgets.dart';
import '../views.dart';

/// This view contains a form allowing users to sign up.
class SignupView extends BaseView {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final AutovalidateMode validate;
  final File? image;
  final Function() onClickSignup;
  final Function(File? image) onSaveImage;
  final String? Function(String? confirmPassword) validateName;
  final Function(String? confirmPassword) onSaveFirstName;
  final Function(String? confirmPassword) onSaveLastName;
  final String? Function(String? email) validateEmail;
  final Function(String? confirmPassword) onSaveEmail;
  final String? Function(String? confirmPassword) validateMobile;
  final Function(String? confirmPassword) onSaveMobile;
  final String? Function(String? confirmPassword) validatePassword;
  final Function(String? confirmPassword) onSavePassword;
  final String? Function(String? confirmPassword) validateConfirmPassword;
  final Function(String? confirmPassword) onSaveConfirmPassword;
  final Function() onClickMobile;

  const SignupView({
    Key? key,
    required this.formKey,
    required this.passwordController,
    required this.validate,
    required this.image,
    required this.onClickSignup,
    required this.onSaveImage,
    required this.validateName,
    required this.onSaveFirstName,
    required this.onSaveLastName,
    required this.validateEmail,
    required this.onSaveEmail,
    required this.validateMobile,
    required this.onSaveMobile,
    required this.validatePassword,
    required this.onSavePassword,
    required this.validateConfirmPassword,
    required this.onSaveConfirmPassword,
    required this.onClickMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme:
              IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
            child: Form(
              key: formKey,
              autovalidateMode: validate,
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Create new account',
                        style: HeadingTextStyle(size: Size.LARGE),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 32, right: 8, bottom: 8),
                      child: ProfilePictureSelector(
                          initialImage: image, onSelected: onSaveImage)),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextInputFormField(
                        hint: 'First Name',
                        inputType: TextInputType.name,
                        onSaved: onSaveFirstName,
                        validator: validateName,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: TextInputFormField(
                            hint: 'Last Name',
                            inputType: TextInputType.name,
                            validator: validateName,
                            onSaved: onSaveLastName)),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: TextInputFormField(
                            hint: 'Email Address',
                            inputType: TextInputType.emailAddress,
                            validator: validateEmail,
                            onSaved: onSaveEmail)),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: InternationalPhoneNumberInput(
                          spaceBetweenSelectorAndTextField: 0,
                          keyboardType: TextInputType.phone,
                          selectorConfig: SelectorConfig(
                              leadingPadding: 8,
                              useEmoji: true,
                              trailingSpace: false,
                              selectorType:
                                  PhoneInputSelectorType.BOTTOM_SHEET),
                          initialValue: PhoneNumber(isoCode: 'US'),
                          keyboardAction: TextInputAction.next,
                          autoValidateMode: validate,
                          searchBoxDecoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8)),
                          inputDecoration:
                              TextFormStyleDecoration(hint: 'Mobile'),
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: primaryColor,
                          validator: validateMobile,
                          onInputChanged: (PhoneNumber number) =>
                              onSaveMobile(number.phoneNumber)),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextInputFormField(
                        hint: 'Password',
                        onSaved: onSavePassword,
                        hide: true,
                        controller: passwordController,
                        validator: validatePassword,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: TextInputFormField(
                            hint: 'Confirm Password',
                            onSubmit: onClickSignup,
                            validator: validateConfirmPassword,
                            hide: true,
                            onSaved: onSaveConfirmPassword)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, top: 40.0),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: borderRadius,
                            side: BorderSide(
                              color: primaryColor,
                            ),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: HeadingTextStyle(
                            size: Size.SMALL,
                            color: isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                        onPressed: onClickSignup,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'OR',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onClickMobile,
                    child: Text(
                      'Sign up with phone number',
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 1),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}

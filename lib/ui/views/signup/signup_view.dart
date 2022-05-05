import 'dart:io';

import 'package:display/display.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phitnest/ui/widgets/decorations/text_field_decoration.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:select_photo/select_photo.dart';
import 'package:validation/validation.dart';

import '../../../constants/constants.dart';
import '../redirected/redirected.dart';
import 'model/signup_model.dart';

/// This view contains a form allowing users to sign up.
class SignupView extends PreAuthenticationView<SignupModel> {
  const SignupView({Key? key}) : super(key: key);

  @override
  init(BuildContext context, SignupModel model) async {
    await super.init(context, model);

    // If we are not redirecting
    if (!await shouldRedirect) {
      // Android camera data
      if (Platform.isAndroid) {
        model.image ??= await retrieveLostData();
      }

      // Finished loading
      model.loading = false;
    }
  }

  @override
  Widget build(BuildContext context, SignupModel model) {
    // This function will show a progress widget until sign up is finished.
    // If the sign up method returns an error, show it in an alert dialog.
    // Otherwise (successful signup), navigate to the home view.
    signupClick() => showProgressUntil(
        context: context,
        message: 'Creating new account, Please wait...',
        showUntil: model.signUp,
        onDone: (result) {
          if (result != null) {
            showAlertDialog(context, 'Login Failed', result);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
          }
        });

    return Scaffold(
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
            key: model.formKey,
            autovalidateMode: model.validate,
            child: Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Create new account',
                      style: TextStyle(
                          color: Color(COLOR_PRIMARY),
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 32, right: 8, bottom: 8),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.grey.shade400,
                        child: ClipOval(
                          child: SizedBox(
                            width: 170,
                            height: 170,
                            child: model.image == null
                                ? Image.asset(
                                    'assets/images/placeholder.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    model.image!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                          left: 80,
                          right: 0,
                          child: FloatingActionButton(
                            backgroundColor: Color(COLOR_ACCENT),
                            child: Icon(
                              Icons.camera_alt,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            mini: true,
                            onPressed: () => selectPhoto(
                                context,
                                'Select Profile Picture',
                                (photo) => model.image = photo),
                          )),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                    child: TextFormField(
                        cursorColor: Color(COLOR_PRIMARY),
                        textAlignVertical: TextAlignVertical.center,
                        validator: validateName,
                        onSaved: (String? val) => model.firstName = val,
                        textInputAction: TextInputAction.next,
                        decoration: TextFieldInputDecoration('First Name')),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                    child: TextFormField(
                      validator: validateName,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: Color(COLOR_PRIMARY),
                      onSaved: (String? val) => model.lastName = val,
                      textInputAction: TextInputAction.next,
                      decoration: TextFieldInputDecoration('Last Name'),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.next,
                      cursorColor: Color(COLOR_PRIMARY),
                      validator: validateEmail,
                      onSaved: (String? val) => model.email = val,
                      decoration: TextFieldInputDecoration('Email Address'),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, right: 8.0, left: 16.0),
                    child: InternationalPhoneNumberInput(
                      autoFocusSearch: true,
                      spaceBetweenSelectorAndTextField: 0,
                      keyboardType: TextInputType.phone,
                      selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                      initialValue: PhoneNumber(isoCode: 'US'),
                      keyboardAction: TextInputAction.next,
                      autoValidateMode: model.validate,
                      searchBoxDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16)),
                      inputDecoration: TextFieldInputDecoration('Mobile'),
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: Color(COLOR_PRIMARY),
                      validator: validateMobile,
                      onInputChanged: (PhoneNumber number) =>
                          model.mobile = number.phoneNumber,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                    child: TextFormField(
                        obscureText: true,
                        textAlignVertical: TextAlignVertical.center,
                        textInputAction: TextInputAction.next,
                        controller: model.passwordController,
                        validator: validatePassword,
                        onSaved: (String? val) => model.password = val,
                        style: TextStyle(fontSize: 18.0),
                        cursorColor: Color(COLOR_PRIMARY),
                        decoration: TextFieldInputDecoration('Password')),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                    child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => signupClick(),
                        obscureText: true,
                        validator: (val) => validateConfirmPassword(
                            model.passwordController.text, val),
                        onSaved: (String? val) => model.confirmPassword = val,
                        style: TextStyle(fontSize: 18.0),
                        cursorColor: Color(COLOR_PRIMARY),
                        decoration:
                            TextFieldInputDecoration('Confirm Password')),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(COLOR_PRIMARY),
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BORDER_RADIUS,
                          side: BorderSide(
                            color: Color(COLOR_PRIMARY),
                          ),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                      onPressed: signupClick,
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
                  onTap: () {
                    Navigator.pushNamed(context, '/mobileAuth');
                  },
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
}

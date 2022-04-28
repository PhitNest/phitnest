import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigation/navigation.dart';
import 'package:display/display_utils.dart';

import '../../screens/screen_utils.dart';
import '../screens.dart';
import 'provider/sign_up_provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignUpScreenProvider(builder: (context, model, functions, child) {
      if (Platform.isAndroid) {
        functions.retrieveLostData();
      }
      return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: DisplayUtils.isDarkMode
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
                color: DisplayUtils.isDarkMode ? Colors.white : Colors.black),
          ),
          body: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                  child: Form(
                      key: model.key,
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
                                        color: DisplayUtils.isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      mini: true,
                                      onPressed: functions.onCameraClick),
                                )
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: double.infinity),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, right: 8.0, left: 8.0),
                              child: TextFormField(
                                cursorColor: Color(COLOR_PRIMARY),
                                textAlignVertical: TextAlignVertical.center,
                                validator: ValidationUtils.validateName,
                                onSaved: functions.updateFirstName,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  fillColor: Colors.white,
                                  hintText: 'First Name',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Color(COLOR_PRIMARY),
                                          width: 2.0)),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: double.infinity),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, right: 8.0, left: 8.0),
                              child: TextFormField(
                                validator: ValidationUtils.validateName,
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: Color(COLOR_PRIMARY),
                                onSaved: functions.updateLastName,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  fillColor: Colors.white,
                                  hintText: 'Last Name',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Color(COLOR_PRIMARY),
                                          width: 2.0)),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: double.infinity),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, right: 8.0, left: 8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                cursorColor: Color(COLOR_PRIMARY),
                                validator: ValidationUtils.validateEmail,
                                onSaved: functions.updateEmail,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  fillColor: Colors.white,
                                  hintText: 'Email Address',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Color(COLOR_PRIMARY),
                                          width: 2.0)),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// user mobile text field, this is hidden in case of sign up with
                          /// phone number
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: double.infinity),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, right: 8.0, left: 8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                cursorColor: Color(COLOR_PRIMARY),
                                validator: ValidationUtils.validateMobile,
                                onSaved: functions.updateMobile,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  fillColor: Colors.white,
                                  hintText: 'Mobile',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Color(COLOR_PRIMARY),
                                          width: 2.0)),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: double.infinity),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, right: 8.0, left: 8.0),
                              child: TextFormField(
                                obscureText: true,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                controller: model.passwordController,
                                validator: ValidationUtils.validatePassword,
                                onSaved: functions.updatePassword,
                                style: TextStyle(fontSize: 18.0),
                                cursorColor: Color(COLOR_PRIMARY),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  fillColor: Colors.white,
                                  hintText: 'Password',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Color(COLOR_PRIMARY),
                                          width: 2.0)),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: double.infinity),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, right: 8.0, left: 8.0),
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => functions.signUp(),
                                obscureText: true,
                                validator: functions.validateConfirmPassword,
                                onSaved: functions.updateConfirmPassword,
                                style: TextStyle(fontSize: 18.0),
                                cursorColor: Color(COLOR_PRIMARY),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  fillColor: Colors.white,
                                  hintText: 'Confirm Password',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Color(COLOR_PRIMARY),
                                          width: 2.0)),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).errorColor),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 40.0, left: 40.0, top: 40.0),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: double.infinity),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(COLOR_PRIMARY),
                                  padding: EdgeInsets.only(top: 12, bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
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
                                    color: DisplayUtils.isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                onPressed: functions.signUp,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(
                              child: Text(
                                'OR',
                                style: TextStyle(
                                    color: DisplayUtils.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigation.push(
                                  context, PhoneAuthScreen(login: false));
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
                      )))));
    });
  }
}

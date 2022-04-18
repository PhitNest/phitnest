import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import 'package:phitnest/constants/constants.dart';
import 'package:phitnest/main.dart';
import 'package:phitnest/helpers/helper.dart';
import 'package:phitnest/models/models.dart';
import 'package:phitnest/screens/screens.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  Position? currentLocation;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: DisplayUtils.isDarkMode(context)
            ? Brightness.dark
            : Brightness.light,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color:
                DisplayUtils.isDarkMode(context) ? Colors.white : Colors.black),
        elevation: 0.0,
      ),
      body: Form(
        key: _key,
        autovalidateMode: _validate,
        child: ListView(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
                child: Text(
                  'Sign In'.tr(),
                  style: TextStyle(
                      color: Color(COLOR_PRIMARY),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 18.0),
                  validator: (val) => AuthenticationUtils.validateEmail(val),
                  onSaved: (val) => email = val,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Color(COLOR_PRIMARY),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    hintText: 'E-mail Address'.tr(),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: Color(COLOR_PRIMARY), width: 2.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  onSaved: (val) => password = val,
                  obscureText: true,
                  validator: (val) => AuthenticationUtils.validatePassword(val),
                  onFieldSubmitted: (password) => _login(),
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 18.0),
                  cursorColor: Color(COLOR_PRIMARY),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    hintText: 'Password'.tr(),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: Color(COLOR_PRIMARY), width: 2.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),

            /// forgot password text, navigates user to ResetPasswordScreen
            /// and this is only visible when logging with email and password
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () =>
                      NavigationUtils.push(context, ResetPasswordScreen()),
                  child: Text(
                    'Forgot password?'.tr(),
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(COLOR_PRIMARY),
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Color(COLOR_PRIMARY))),
                  ),
                  child: Text(
                    'Log In'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: DisplayUtils.isDarkMode(context)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onPressed: () => _login(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'OR'.tr(),
                  style: TextStyle(
                      color: DisplayUtils.isDarkMode(context)
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, bottom: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton.icon(
                  label: Expanded(
                    child: Text(
                      'Facebook Login'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset(
                      'assets/images/facebook_logo.png',
                      color: Colors.white,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(FACEBOOK_BUTTON_COLOR),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Color(FACEBOOK_BUTTON_COLOR),
                      ),
                    ),
                  ),
                  onPressed: () async => loginWithFacebook(),
                ),
              ),
            ),
            FutureBuilder<bool>(
              future: apple.TheAppleSignIn.isAvailable(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator.adaptive();
                }
                if (!snapshot.hasData || (snapshot.data != true)) {
                  return Container();
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, bottom: 20),
                    child: apple.AppleSignInButton(
                      cornerRadius: 25.0,
                      type: apple.ButtonType.signIn,
                      style: DisplayUtils.isDarkMode(context)
                          ? apple.ButtonStyle.white
                          : apple.ButtonStyle.black,
                      onPressed: () => loginWithApple(),
                    ),
                  );
                }
              },
            ),

            InkWell(
              onTap: () {
                NavigationUtils.push(
                    context, PhoneNumberInputScreen(login: true));
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Login with phone number'.tr(),
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _login() async {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState!.save();
      await _loginWithEmailAndPassword();
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  _loginWithEmailAndPassword() async {
    await DialogUtils.showProgress(
        context, 'Logging in, please wait...'.tr(), false);
    currentLocation = await LocationUtils.getCurrentLocation();
    if (currentLocation != null) {
      dynamic result = await FirebaseUtils.loginWithEmailAndPassword(
          email!.trim(), password!.trim(), currentLocation!);
      await DialogUtils.hideProgress();
      if (result != null && result is User) {
        PhitnestApp.currentUser = result;
        NavigationUtils.pushAndRemoveUntil(
            context, HomeScreen(user: result), false);
      } else if (result != null && result is String) {
        DialogUtils.showAlertDialog(
            context, 'Couldn\'t Authenticate'.tr(), result);
      } else {
        DialogUtils.showAlertDialog(context, 'Couldn\'t Authenticate'.tr(),
            'Login failed, Please try again.'.tr());
      }
    } else {
      await DialogUtils.hideProgress();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location is required to match you with people from '
                'your area.'
            .tr()),
        duration: Duration(seconds: 6),
      ));
    }
  }

  loginWithFacebook() async {
    try {
      await DialogUtils.showProgress(
          context, 'Logging in, Please wait...'.tr(), false);
      dynamic result = await FirebaseUtils.loginWithFacebook();
      await DialogUtils.hideProgress();
      if (result != null && result is User) {
        PhitnestApp.currentUser = result;
        NavigationUtils.pushAndRemoveUntil(
            context, HomeScreen(user: result), false);
      } else if (result != null && result is String) {
        DialogUtils.showAlertDialog(context, 'Error'.tr(), result.tr());
      } else {
        DialogUtils.showAlertDialog(
            context, 'Error', 'Couldn\'t login with facebook.'.tr());
      }
    } catch (e, s) {
      await DialogUtils.hideProgress();
      print('_LoginScreen.loginWithFacebook $e $s');
      DialogUtils.showAlertDialog(
          context, 'Error', 'Couldn\'t login with facebook.'.tr());
    }
  }

  loginWithApple() async {
    try {
      await DialogUtils.showProgress(
          context, 'Logging in, Please wait...'.tr(), false);
      dynamic result = await FirebaseUtils.loginWithApple();
      await DialogUtils.hideProgress();
      if (result != null && result is User) {
        PhitnestApp.currentUser = result;
        NavigationUtils.pushAndRemoveUntil(
            context, HomeScreen(user: result), false);
      } else if (result != null && result is String) {
        DialogUtils.showAlertDialog(context, 'Error'.tr(), result.tr());
      } else {
        DialogUtils.showAlertDialog(
            context, 'Error', 'Couldn\'t login with apple.'.tr());
      }
    } catch (e, s) {
      await DialogUtils.hideProgress();
      print('_LoginScreen.loginWithApple $e $s');
      DialogUtils.showAlertDialog(
          context, 'Error', 'Couldn\'t login with apple.'.tr());
    }
  }
}

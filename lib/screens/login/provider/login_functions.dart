import 'package:flutter/material.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../../services/services.dart';
import '../../screen_utils.dart';
import '../../screens.dart';
import 'model/login_model.dart';

class LoginFunctions {
  final BuildContext context;
  final BackEndModel backEnd;
  final LoginModel model;

  const LoginFunctions(
      {required this.context, required this.backEnd, required this.model});

  Future<void> login() async {
    if (model.formKey.currentState?.validate() ?? false) {
      model.formKey.currentState!.save();
      await _loginWithEmailAndPassword();
    } else {
      model.validate = AutovalidateMode.onUserInteraction;
    }
  }

  void updateEmail(String? email) {
    model.email = email;
  }

  void updatePassword(String? password) {
    model.password = password;
  }

  Future<bool> showApple() => TheAppleSignIn.isAvailable();

  void resetPassword() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => ResetPasswordScreen()));

  void loginWithPhone() => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PhoneAuthScreen(login: true)));

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  Future<void> _loginWithEmailAndPassword() async {
    await DialogUtils.showProgress(
        context, 'Logging in, please wait...', false);
    model.currentLocation = await LocationUtils.getCurrentLocation();
    if (model.currentLocation != null) {
      dynamic result = await backEnd.loginWithEmail(
          model.email!.trim(), model.password!.trim(), model.currentLocation!);
      await DialogUtils.hideProgress();
      if (result == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const RedirectorScreen()),
            (route) => false);
      } else {
        DialogUtils.showAlertDialog(context, 'Couldn\'t Authenticate',
            'Login failed, Please try again.');
      }
    } else {
      await DialogUtils.hideProgress();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location is required to match you with people from '
            'your area.'),
        duration: Duration(seconds: 6),
      ));
    }
  }

  Future<void> loginWithFacebook() async {
    try {
      await DialogUtils.showProgress(
          context, 'Logging in, Please wait...', false);
      dynamic result = await backEnd.loginWithFacebook();
      await DialogUtils.hideProgress();
      if (result == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const RedirectorScreen()),
            (route) => false);
      } else {
        DialogUtils.showAlertDialog(context, 'Error', result.tr());
      }
    } catch (e, s) {
      await DialogUtils.hideProgress();
      print('_LoginScreen.loginWithFacebook $e $s');
      DialogUtils.showAlertDialog(
          context, 'Error', 'Couldn\'t login with facebook.');
    }
  }

  Future<void> loginWithApple() async {
    try {
      await DialogUtils.showProgress(
          context, 'Logging in, Please wait...', false);
      dynamic result = await backEnd.loginWithApple();
      await DialogUtils.hideProgress();
      if (result == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const RedirectorScreen()),
            (route) => false);
      } else {
        DialogUtils.showAlertDialog(
            context, 'Error', 'Couldn\'t login with apple.');
      }
    } catch (e, s) {
      await DialogUtils.hideProgress();
      print('_LoginScreen.loginWithApple $e $s');
      DialogUtils.showAlertDialog(
          context, 'Error', 'Couldn\'t login with apple.');
    }
  }
}

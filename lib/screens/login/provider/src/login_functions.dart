import 'package:flutter/material.dart';
import 'package:location/location_utils.dart';
import 'package:navigation/navigation.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../../../services/backend_model.dart';
import '../../../screen_utils.dart';
import '../../../screens.dart';
import 'login_model.dart';

class LoginFunctions {
  final BuildContext context;
  final LoginModel model;

  late final BackEndModel backEnd;

  LoginFunctions({required this.context, required this.model}) {
    backEnd = BackEndModel.getBackEnd(context);
  }

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

  void resetPassword() => Navigation.push(context, ResetPasswordScreen());

  void loginWithPhone() =>
      Navigation.push(context, PhoneAuthScreen(login: true));

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
        Navigation.pushAndRemoveUntil(context, const RedirectorScreen());
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
        Navigation.pushAndRemoveUntil(context, const RedirectorScreen());
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
        Navigation.pushAndRemoveUntil(context, const RedirectorScreen());
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

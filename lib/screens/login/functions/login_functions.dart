import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../../../app.dart';
import '../provider/login_provider.dart';

class LoginFunctions {
  final BuildContext context;
  final LoginScreenState state;

  LoginFunctions(this.context, this.state);

  Future<void> login() async {
    if (state.formKey.currentState?.validate() ?? false) {
      state.formKey.currentState!.save();
      await loginWithEmailAndPassword();
    } else {
      state.validate = AutovalidateMode.onUserInteraction;
    }
  }

  void updateEmail(String? email) {
    state.email = email;
  }

  void updatePassword(String? password) {
    state.password = password;
  }

  Future<bool> showApple() => apple.TheAppleSignIn.isAvailable();

  void resetPassword() => NavigationUtils.push(
        context,
        ResetPasswordScreen(),
      );

  void loginWithPhone() =>
      NavigationUtils.push(context, PhoneAuthScreen(login: true));

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  Future<void> loginWithEmailAndPassword() async {
    BackEndModel backEnd = Provider.of<BackEndModel>(context, listen: false);
    await DialogUtils.showProgress(
        context, 'Logging in, please wait...'.tr(), false);
    state.currentLocation = await LocationUtils.getCurrentLocation();
    if (state.currentLocation != null) {
      dynamic result = await backEnd.loginWithEmail(
          state.email!.trim(), state.password!.trim(), state.currentLocation!);
      await DialogUtils.hideProgress();
      if (result == null) {
        NavigationUtils.pushAndRemoveUntil(
            context, const RedirectorScreen(), false);
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

  Future<void> loginWithFacebook() async {
    BackEndModel backEnd = Provider.of<BackEndModel>(context, listen: false);
    try {
      await DialogUtils.showProgress(
          context, 'Logging in, Please wait...'.tr(), false);
      dynamic result = await backEnd.loginWithFacebook();
      await DialogUtils.hideProgress();
      if (result == null) {
        NavigationUtils.pushAndRemoveUntil(
            context, const RedirectorScreen(), false);
      } else {
        DialogUtils.showAlertDialog(context, 'Error'.tr(), result.tr());
      }
    } catch (e, s) {
      await DialogUtils.hideProgress();
      print('_LoginScreen.loginWithFacebook $e $s');
      DialogUtils.showAlertDialog(
          context, 'Error', 'Couldn\'t login with facebook.'.tr());
    }
  }

  Future<void> loginWithApple() async {
    BackEndModel backEnd = Provider.of<BackEndModel>(context, listen: false);
    try {
      await DialogUtils.showProgress(
          context, 'Logging in, Please wait...'.tr(), false);
      dynamic result = await backEnd.loginWithApple();
      await DialogUtils.hideProgress();
      if (result == null) {
        NavigationUtils.pushAndRemoveUntil(
            context, const RedirectorScreen(), false);
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

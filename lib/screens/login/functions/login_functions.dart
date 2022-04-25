import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app.dart';
import '../provider/login_provider.dart';

class LoginFunctions {
  final BuildContext context;
  final ScreenState state;

  LoginFunctions(this.context, this.state);

  login() async {
    if (state.formKey.currentState?.validate() ?? false) {
      state.formKey.currentState!.save();
      await loginWithEmailAndPassword();
    } else {
      state.validate = AutovalidateMode.onUserInteraction;
    }
  }

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  loginWithEmailAndPassword() async {
    BackEndModel backEnd = Provider.of<BackEndModel>(context, listen: false);
    await DialogUtils.showProgress(
        context, 'Logging in, please wait...'.tr(), false);
    state.currentLocation = await LocationUtils.getCurrentLocation();
    if (state.currentLocation != null) {
      dynamic result = await backEnd.loginWithEmail(
          state.email!.trim(), state.password!.trim(), state.currentLocation!);
      await DialogUtils.hideProgress();
      if (result == null) {
        await backEnd.updateCurrentUser(result);
        NavigationUtils.pushAndRemoveUntil(context, HomeScreen(), false);
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
    BackEndModel backEnd = Provider.of<BackEndModel>(context, listen: false);
    try {
      await DialogUtils.showProgress(
          context, 'Logging in, Please wait...'.tr(), false);
      dynamic result = await backEnd.loginWithFacebook();
      await DialogUtils.hideProgress();
      if (result == null) {
        NavigationUtils.pushAndRemoveUntil(context, HomeScreen(), false);
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

  loginWithApple() async {
    BackEndModel backEnd = Provider.of<BackEndModel>(context, listen: false);
    try {
      await DialogUtils.showProgress(
          context, 'Logging in, Please wait...'.tr(), false);
      dynamic result = await backEnd.loginWithApple();
      await DialogUtils.hideProgress();
      if (result == null) {
        NavigationUtils.pushAndRemoveUntil(context, HomeScreen(), false);
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

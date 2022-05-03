import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../main.dart';
import '../../../../model/User.dart';
import '../../../../services/FirebaseHelper.dart';
import '../../../../services/helper.dart';
import '../../home/HomeScreen.dart';

class LoginModel extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  Position? currentLocation;
  String? email, password;

  AutovalidateMode _validate = AutovalidateMode.disabled;
  AutovalidateMode get validate => _validate;

  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }

  login(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      await loginWithEmailAndPassword(context);
    } else {
      validate = AutovalidateMode.onUserInteraction;
    }
  }

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  loginWithEmailAndPassword(BuildContext context) async {
    await showProgress(context, 'Logging in, please wait...', false);
    currentLocation = await getCurrentLocation();
    if (currentLocation != null) {
      dynamic result = await FireStoreUtils.loginWithEmailAndPassword(
          email!.trim(), password!.trim(), currentLocation!);
      await hideProgress();
      if (result != null && result is User) {
        MyAppState.currentUser = result;
        pushAndRemoveUntil(context, HomeScreen(user: result), false);
      } else if (result != null && result is String) {
        showAlertDialog(context, 'Couldn\'t Authenticate', result);
      } else {
        showAlertDialog(context, 'Couldn\'t Authenticate',
            'Login failed, Please try again.');
      }
    } else {
      await hideProgress();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location is required to match you with people from '
            'your area.'),
        duration: Duration(seconds: 6),
      ));
    }
  }

  loginWithApple(BuildContext context) async {
    try {
      await showProgress(context, 'Logging in, Please wait...', false);
      dynamic result = await FireStoreUtils.loginWithApple();
      await hideProgress();
      if (result != null && result is User) {
        MyAppState.currentUser = result;
        pushAndRemoveUntil(context, HomeScreen(user: result), false);
      } else if (result != null && result is String) {
        showAlertDialog(context, 'Error', result);
      } else {
        showAlertDialog(context, 'Error', 'Couldn\'t login with apple.');
      }
    } catch (e, s) {
      await hideProgress();
      print('_LoginScreen.loginWithApple $e $s');
      showAlertDialog(context, 'Error', 'Couldn\'t login with apple.');
    }
  }
}

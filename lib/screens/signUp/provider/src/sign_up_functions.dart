import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location_utils.dart';
import '../../../../services/backend_model.dart';
import 'package:validation/validation_utils.dart';

import '../../../../utils/utils.dart';
import '../../../screens.dart';
import 'sign_up_model.dart';

class SignUpFunctions {
  final BuildContext context;
  final SignUpModel model;

  late final BackEndModel backEnd;

  SignUpFunctions({required this.context, required this.model});

  void updateEmail(String? email) {
    model.email = email;
  }

  void updateFirstName(String? name) {
    model.firstName = name;
  }

  void updateLastName(String? name) {
    model.lastName = name;
  }

  void updateMobile(String? mobile) {
    model.mobile = mobile;
  }

  void updatePassword(String? password) {
    model.password = password;
  }

  void updateConfirmPassword(String? confirmPassword) {
    model.confirmPassword = confirmPassword;
  }

  String? validateConfirmPassword(String? confirmPassword) {
    return ValidationUtils.validateConfirmPassword(
        model.passwordController.text, confirmPassword);
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse? response =
        await model.imagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      model.image = File(response.file!.path);
    }
  }

  signUp() async {
    if (model.key.currentState?.validate() ?? false) {
      model.key.currentState!.save();
      await signUpWithEmailAndPassword();
    } else {
      model.validate = AutovalidateMode.onUserInteraction;
    }
  }

  signUpWithEmailAndPassword() async {
    BackEndModel backEnd = BackEndModel.getBackEnd(context);
    await DialogUtils.showProgress(
        context, 'Creating new account, Please wait...', false);
    model.signUpLocation = await LocationUtils.getCurrentLocation();
    if (model.signUpLocation != null) {
      dynamic result = await backEnd.firebaseSignUpWithEmailAndPassword(
          model.email!.trim(),
          model.password!.trim(),
          model.image,
          model.firstName!,
          model.lastName!,
          model.signUpLocation!,
          model.mobile!);
      await DialogUtils.hideProgress();
      if (result == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const RedirectorScreen()),
            (route) => false);
      } else {
        DialogUtils.showAlertDialog(context, 'Failed', 'Couldn\'t sign up');
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

  onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'Add profile picture',
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Choose from gallery'),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await model.imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) model.image = File(image.path);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Take a picture'),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await model.imagePicker.pickImage(source: ImageSource.camera);
            if (image != null) model.image = File(image.path);
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}

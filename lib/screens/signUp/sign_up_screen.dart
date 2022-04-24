import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../providers/signUpScreen/sign_up_model.dart';
import '../screens.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SignUpScreenModel(),
        child: Consumer<SignUpScreenModel>(
            builder: ((context, SignUpScreenModel model, child) {
          if (Platform.isAndroid) {
            retrieveLostData(context, model);
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
                  child: formUI(context, model),
                ),
              ),
            ),
          );
        })));
  }

  Future<void> retrieveLostData(
      BuildContext context, SignUpScreenModel model) async {
    final LostDataResponse? response =
        await model.imagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      model.image = File(response.file!.path);
    }
  }

  _onCameraClick(BuildContext context, SignUpScreenModel model) {
    final action = CupertinoActionSheet(
      message: Text(
        'Add profile picture'.tr(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Choose from gallery'.tr()),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await model.imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) model.image = File(image.path);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Take a picture'.tr()),
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
        child: Text('Cancel'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Widget formUI(BuildContext context, SignUpScreenModel model) {
    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Create new account'.tr(),
              style: TextStyle(
                  color: Color(COLOR_PRIMARY),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            )),
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, top: 32, right: 8, bottom: 8),
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
                            'assets/images/placeholder.jpg'.tr(),
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
                      color:
                          DisplayUtils.isDarkMode ? Colors.black : Colors.white,
                    ),
                    mini: true,
                    onPressed: () => _onCameraClick(context, model)),
              )
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
              cursorColor: Color(COLOR_PRIMARY),
              textAlignVertical: TextAlignVertical.center,
              validator: ValidationUtils.validateName,
              onSaved: (String? val) {
                model.firstName = val;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                fillColor: Colors.white,
                hintText: 'First Name'.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
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
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
              validator: ValidationUtils.validateName,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: Color(COLOR_PRIMARY),
              onSaved: (String? val) {
                model.lastName = val;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                fillColor: Colors.white,
                hintText: 'Last Name'.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
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
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.next,
              cursorColor: Color(COLOR_PRIMARY),
              validator: ValidationUtils.validateEmail,
              onSaved: (String? val) {
                model.email = val;
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                fillColor: Colors.white,
                hintText: 'Email Address'.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
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

        /// user mobile text field, this is hidden in case of sign up with
        /// phone number
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.next,
              cursorColor: Color(COLOR_PRIMARY),
              validator: ValidationUtils.validateMobile,
              onSaved: (String? val) {
                model.mobile = val;
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                fillColor: Colors.white,
                hintText: 'Mobile'.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
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
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
              obscureText: true,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.next,
              controller: model.passwordController,
              validator: ValidationUtils.validatePassword,
              onSaved: (String? val) {
                model.password = val;
              },
              style: TextStyle(fontSize: 18.0),
              cursorColor: Color(COLOR_PRIMARY),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                fillColor: Colors.white,
                hintText: 'Password'.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
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
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _signUp(context, model),
              obscureText: true,
              validator: (val) => ValidationUtils.validateConfirmPassword(
                  model.passwordController.text, val),
              onSaved: (String? val) {
                model.confirmPassword = val;
              },
              style: TextStyle(fontSize: 18.0),
              cursorColor: Color(COLOR_PRIMARY),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                fillColor: Colors.white,
                hintText: 'Confirm Password'.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
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
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
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
                'Sign Up'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: DisplayUtils.isDarkMode ? Colors.black : Colors.white,
                ),
              ),
              onPressed: () => _signUp(context, model),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              'OR'.tr(),
              style: TextStyle(
                  color: DisplayUtils.isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            NavigationUtils.push(context, PhoneNumberInputScreen(login: false));
          },
          child: Text(
            'Sign up with phone number'.tr(),
            style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 1),
          ),
        )
      ],
    );
  }

  _signUp(BuildContext context, SignUpScreenModel model) async {
    if (model.key.currentState?.validate() ?? false) {
      model.key.currentState!.save();
      await _signUpWithEmailAndPassword(context, model);
    } else {
      model.validate = AutovalidateMode.onUserInteraction;
    }
  }

  _signUpWithEmailAndPassword(
      BuildContext context, SignUpScreenModel model) async {
    await DialogUtils.showProgress(
        context, 'Creating new account, Please wait...'.tr(), false);
    model.signUpLocation = await LocationUtils.getCurrentLocation();
    if (model.signUpLocation != null) {
      dynamic result = await FirebaseUtils.firebaseSignUpWithEmailAndPassword(
          model.email!.trim(),
          model.password!.trim(),
          model.image,
          model.firstName!,
          model.lastName!,
          model.signUpLocation!,
          model.mobile!);
      await DialogUtils.hideProgress();
      if (result != null && result is UserModel) {
        NavigationUtils.pushAndRemoveUntil(
            context, HomeScreen(user: result), false);
      } else if (result != null && result is String) {
        DialogUtils.showAlertDialog(context, 'Failed'.tr(), result);
      } else {
        DialogUtils.showAlertDialog(
            context, 'Failed'.tr(), 'Couldn\'t sign up'.tr());
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
}

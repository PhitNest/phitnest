import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;
import 'package:display/display_utils.dart';

import '../../screens/screen_utils.dart';
import '../../services/services.dart';
import '../../models/models.dart';

enum AuthProviders { PASSWORD, PHONE, FACEBOOK, APPLE }

class ReAuthUserScreen extends StatefulWidget {
  final UserModel user;
  final AuthProviders provider;
  final String? email;
  final String? phoneNumber;
  final bool deleteUser;

  ReAuthUserScreen(
      {Key? key,
      required this.user,
      required this.provider,
      this.email,
      this.phoneNumber,
      required this.deleteUser})
      : super(key: key);

  @override
  _ReAuthUserScreenState createState() => _ReAuthUserScreenState();
}

class _ReAuthUserScreenState extends State<ReAuthUserScreen> {
  TextEditingController _passwordController = TextEditingController();
  late Widget body = CircularProgressIndicator.adaptive();
  String? _verificationID;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      buildBody();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Text(
                  'Please Re-Authenticate in order to perform this action.',
                  textAlign: TextAlign.center,
                ),
              ),
              body,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: 'Password'.tr()),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(COLOR_PRIMARY),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
            onPressed: () async => passwordButtonPressed(),
            child: Text(
              'Verify'.tr(),
              style: TextStyle(
                  color: DisplayUtils.isDarkMode ? Colors.black : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFacebookButton() {
    return ElevatedButton.icon(
      label: Expanded(
        child: Text(
          'Facebook Verify'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: Color(FACEBOOK_BUTTON_COLOR),
          ),
        ),
      ),
      onPressed: () async => facebookButtonPressed(),
    );
  }

  Widget buildAppleButton() {
    return FutureBuilder<bool>(
      future: apple.TheAppleSignIn.isAvailable(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator.adaptive();
        }
        if (!snapshot.hasData || (snapshot.data != true)) {
          return Center(
              child:
                  Text('Apple sign in is not available on this device.'.tr()));
        } else {
          return apple.AppleSignInButton(
            cornerRadius: 12.0,
            type: apple.ButtonType.continueButton,
            style: DisplayUtils.isDarkMode
                ? apple.ButtonStyle.white
                : apple.ButtonStyle.black,
            onPressed: () => appleButtonPressed(),
          );
        }
      },
    );
  }

  Widget buildPhoneField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: PinCodeTextField(
            length: 6,
            appContext: context,
            keyboardType: TextInputType.phone,
            backgroundColor: Colors.transparent,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 40,
                fieldWidth: 40,
                activeColor: Color(COLOR_PRIMARY),
                activeFillColor: DisplayUtils.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade100,
                selectedFillColor: Colors.transparent,
                selectedColor: Color(COLOR_PRIMARY),
                inactiveColor: Colors.grey.shade600,
                inactiveFillColor: Colors.transparent),
            enableActiveFill: true,
            onCompleted: (v) {
              _submitCode(v);
            },
            onChanged: (value) {
              print(value);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  passwordButtonPressed() async {
    if (_passwordController.text.isEmpty) {
      DialogUtils.showAlertDialog(context, 'Empty Password'.tr(),
          'Password is required to update email'.tr());
    } else {
      await DialogUtils.showProgress(context, 'Verifying...'.tr(), false);
      try {
        UserCredential? result = await BackEndModel.getBackEnd(context)
            .reAuthUser(widget.provider,
                email: widget.user.email, password: _passwordController.text);
        if (result == null) {
          await DialogUtils.hideProgress();
          DialogUtils.showAlertDialog(context, 'Couldn\'t verify'.tr(),
              'Please double check the password and try again.'.tr());
        } else {
          if (result.user != null) {
            if (widget.email != null)
              await result.user!.updateEmail(widget.email!);
            await DialogUtils.hideProgress();
            Navigator.pop(context, true);
          } else {
            await DialogUtils.hideProgress();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Couldn\'t verify, Please try again.'.tr(),
                  style: TextStyle(fontSize: 17),
                ),
              ),
            );
          }
        }
      } catch (e, s) {
        print('_ReAuthUserScreenState.passwordButtonPressed $e $s');
        await DialogUtils.hideProgress();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Couldn\'t verify, Please try again.'.tr(),
              style: TextStyle(fontSize: 17),
            ),
          ),
        );
      }
    }
  }

  facebookButtonPressed() async {
    try {
      await DialogUtils.showProgress(context, 'Verifying...'.tr(), false);
      AccessToken? token;
      FacebookAuth facebookAuth = FacebookAuth.instance;
      if (await facebookAuth.accessToken == null) {
        LoginResult result = await facebookAuth.login();
        if (result.status == LoginStatus.success) {
          token = await facebookAuth.accessToken;
        }
      } else {
        token = await facebookAuth.accessToken;
      }
      if (token != null)
        await BackEndModel.getBackEnd(context)
            .reAuthUser(widget.provider, accessToken: token);
      await DialogUtils.hideProgress();
      Navigator.pop(context, true);
    } catch (e, s) {
      await DialogUtils.hideProgress();
      print('facebookButtonPressed $e $s');
      DialogUtils.showAlertDialog(
          context, 'Error', 'Couldn\'t verify with facebook.'.tr());
    }
  }

  appleButtonPressed() async {
    try {
      await DialogUtils.showProgress(context, 'Verifying...'.tr(), false);
      final appleCredential = await apple.TheAppleSignIn.performRequests([
        apple.AppleIdRequest(
            requestedScopes: [apple.Scope.email, apple.Scope.fullName])
      ]);
      if (appleCredential.error != null) {
        DialogUtils.showAlertDialog(
            context, 'Error', 'Couldn\'t verify with apple.'.tr());
      }
      if (appleCredential.status == apple.AuthorizationStatus.authorized) {
        await BackEndModel.getBackEnd(context)
            .reAuthUser(widget.provider, appleCredential: appleCredential);
      }
      await DialogUtils.hideProgress();
      Navigator.pop(context, true);
    } catch (e, s) {
      await DialogUtils.hideProgress();
      print('appleButtonPressed $e $s');
      DialogUtils.showAlertDialog(
          context, 'Error', 'Couldn\'t verify with apple.'.tr());
    }
  }

  _submitPhoneNumber() async {
    BackEndModel backEnd = BackEndModel.getBackEnd(context);
    await DialogUtils.showProgress(context, 'Sending code...'.tr(), true);
    await backEnd.firebaseSubmitPhoneNumber(
        backEnd.currentUser!.firstName,
        backEnd.currentUser!.lastName,
        Position(
            longitude: 0,
            latitude: 0,
            timestamp: DateTime(0),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0),
        widget.phoneNumber!, (String verificationId) {
      if (mounted) {
        DialogUtils.hideProgress();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Code verification timeout, request new code.'.tr(),
            ),
          ),
        );
      }
    }, (String? verificationId, int? forceResendingToken) async {
      print('_ReAuthUserScreenState._submitPhoneNumber $verificationId');
      if (mounted) {
        print('_ReAuthUserScreenState.mounted');
        await DialogUtils.hideProgress();
        _verificationID = verificationId;
      }
    }, (Exception error) async {
      if (mounted) {
        await DialogUtils.hideProgress();
        print('$error');
        String message = 'An error has occurred, please try again.'.tr();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
            ),
          ),
        );
        Navigator.pop(context);
      }
    }, () async {});
  }

  void _submitCode(String code) async {
    await DialogUtils.showProgress(context, 'Verifying...'.tr(), false);
    try {
      if (_verificationID != null) {
        if (widget.deleteUser) {
          await BackEndModel.getBackEnd(context).reAuthUser(widget.provider,
              verificationId: _verificationID!, smsCode: code);
        } else {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              smsCode: code, verificationId: _verificationID!);
          await FirebaseAuth.instance.currentUser!
              .updatePhoneNumber(credential);
        }
        await DialogUtils.hideProgress();
        Navigator.pop(context, true);
      } else {
        await DialogUtils.hideProgress();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Couldn\'t get verification ID'.tr()),
            duration: Duration(seconds: 6),
          ),
        );
      }
    } on FirebaseAuthException catch (exception) {
      print('_ReAuthUserScreenState._submitCode ${exception.toString()}');
      await DialogUtils.hideProgress();
      Navigator.pop(context);

      String message = 'An error has occurred, please try again.'.tr();
      switch (exception.code) {
        case 'invalid-verification-code':
          message = 'Invalid code or has been expired.'.tr();
          break;
        case 'user-disabled':
          message = 'This user has been disabled.'.tr();
          break;
        default:
          message = 'An error has occurred, please try again.'.tr();
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );
    } catch (e, s) {
      print('_PhoneNumberInputScreenState._submitCode $e $s');
      await DialogUtils.hideProgress();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error has occurred, please try again.'.tr(),
          ),
        ),
      );
    }
  }

  void buildBody() async {
    switch (widget.provider) {
      case AuthProviders.PASSWORD:
        body = buildPasswordField();
        break;
      case AuthProviders.PHONE:
        await _submitPhoneNumber();
        body = buildPhoneField();
        break;
      case AuthProviders.FACEBOOK:
        body = buildFacebookButton();
        break;
      case AuthProviders.APPLE:
        body = buildAppleButton();
        break;
    }
    setState(() {});
  }
}

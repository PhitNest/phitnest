import 'package:device/device.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/widgets.dart';
import '../views.dart';

/// This is the auth screen view
class AuthView extends BaseView {
  final Function() onClickLogin;
  final Function() onClickSignup;

  const AuthView({
    required this.onClickLogin,
    required this.onClickSignup,
  }) : super();

  Widget build(BuildContext context) {
    double vertPadding = MediaQuery.of(context).size.height / 10;
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
        // Center everything
        body: Center(
      // This scroll view blocks render overflows when the user has the
      // keyboard open (popping back from login or signup with keyboard
      // still open)
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LogoWidget(
            light: true,
            showText: true,
            scale: 0.75,
            padding: EdgeInsets.only(top: vertPadding * 2),
          ),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(bottom: vertPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  key: Key("auth_signIn"),
                  minWidth: buttonWidth,
                  text: 'Sign In',
                  textColor: Colors.black,
                  buttonColor: Color.fromARGB(255, 208, 233, 236),
                  onClick: onClickLogin,
                ),
                StyledButton(
                  key: Key("auth_register"),
                  minWidth: buttonWidth,
                  text: 'Register',
                  onClick: onClickSignup,
                  textColor: Colors.black,
                  buttonColor: Colors.white,
                  buttonOutline: primaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

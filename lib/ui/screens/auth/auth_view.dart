import 'package:display/display.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/ui/widgets/logo/logo_widget.dart';
import 'package:phitnest/ui/widgets/styledButton/styled_button.dart';

import '../../../constants/constants.dart';
import '../views.dart';

/// This is the auth screen view
class AuthView extends BaseView {
  final Function() onClickLogin;
  final Function() onClickSignup;

  const AuthView({
    Key? key,
    required this.onClickLogin,
    required this.onClickSignup,
  }) : super(key: key);

  Widget build(BuildContext context) => Scaffold(
          body: Center(
              // This scroll view blocks render overflows when the user has the
              // keyboard open (popping back from login or signup with keyboard
              // still open)
              child: SingleChildScrollView(
                  child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(
              scale: 2,
            ),
            Text(
              'Connecting Communities',
              textAlign: TextAlign.center,
              style: HeadingTextStyle(size: Size.MEDIUM),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Match and get active with people in your area',
                    style: BodyTextStyle(size: Size.LARGE),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 20),
                    child: StyledButton(
                      text: 'Log In',
                      onClick: onClickLogin,
                    ),
                  ),
                  StyledButton(
                    text: 'Sign Up',
                    onClick: onClickSignup,
                    buttonColor: Colors.white,
                    textColor: primaryColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ))));
}

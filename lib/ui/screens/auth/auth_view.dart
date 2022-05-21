import 'package:device/device.dart';
import 'package:flutter/material.dart';

import '../../common/textStyles/text_styles.dart';
import '../../common/widgets/widgets.dart';
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
          // Center everything
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
              showText: true,
              padding: EdgeInsets.symmetric(vertical: 30),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Connecting Communities',
                  textAlign: TextAlign.center,
                  style: HeadingTextStyle(size: TextSize.MEDIUM),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Let\'s promote health and fitness together',
                        style: BodyTextStyle(size: TextSize.LARGE),
                        textAlign: TextAlign.center,
                      )),
                  StyledButton(
                    text: 'Log In',
                    onClick: onClickLogin,
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

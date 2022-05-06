import 'package:display/display.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../widgets/widgets.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              LOGO_PATH,
              width: 150.0,
              height: 150.0,
              color: primaryColor,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 32, right: 16, bottom: 8),
              child: Text(
                'Find your soul mate',
                textAlign: TextAlign.center,
                style: HeadingTextStyle(size: Size.MEDIUM),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Text(
                'Match and chat with people you like from your area',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    textStyle:
                        HeadingTextStyle(size: Size.SMALL, color: Colors.white),
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: borderRadius,
                        side: BorderSide(color: primaryColor)),
                  ),
                  child: Text(
                    'Log In',
                    style:
                        HeadingTextStyle(size: Size.SMALL, color: Colors.white),
                  ),
                  onPressed: onClickLogin,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 40.0, left: 40.0, top: 20, bottom: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.only(top: 12, bottom: 12),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: borderRadius,
                        side: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: HeadingTextStyle(size: Size.SMALL),
                  ),
                  onPressed: onClickSignup,
                ),
              ),
            )
          ],
        ),
      )));
}

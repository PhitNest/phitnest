import 'package:display/display.dart';
import 'package:flutter/material.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../../widgets/widgets.dart';
import '../views.dart';

/// This view contains a form and makes login requests to authentication
/// service.
class LoginView extends BaseView {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode validate;
  final String? Function(String? email) validateEmail;
  final Function(String? email) onSaveEmail;
  final String? Function(String? password) validatePassword;
  final Function(String? password) onSavePassword;
  final Function(String method) onClickLogin;
  final Function() onClickResetPassword;
  final Function() onClickMobile;

  const LoginView(
      {Key? key,
      required this.formKey,
      required this.validate,
      required this.validateEmail,
      required this.onSaveEmail,
      required this.validatePassword,
      required this.onSavePassword,
      required this.onClickLogin,
      required this.onClickResetPassword,
      required this.onClickMobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This function will show a progress widget while we wait for a login
    // request to go through the authentication service. This will show an alert
    // with an error message if there is an error or it will redirect the user
    // to the home view.

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        elevation: 0.0,
      ),
      body: Form(
        key: formKey,
        autovalidateMode: validate,
        child: ListView(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
                child: Text(
                  'Sign In',
                  style: HeadingTextStyle(size: Size.LARGE),
                ),
              ),
            ),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                  child: TextInputFormField(
                    hint: 'Email Address',
                    onSaved: onSaveEmail,
                    inputType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                )),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                  child: TextInputFormField(
                    hint: 'Password',
                    validator: validatePassword,
                    onSaved: onSavePassword,
                    hide: true,
                    onSubmit: () => onClickLogin('email'),
                  )),
            ),

            /// Forgot password text, navigates user to ResetPasswordScreen
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onClickResetPassword,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: borderRadius,
                            side: BorderSide(color: primaryColor)),
                      ),
                      child: Text(
                        'Log In',
                        style: HeadingTextStyle(
                          size: Size.SMALL,
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                      onPressed: () => onClickLogin('email'))),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ),
            // Apple login UI
            FutureBuilder<bool>(
              future: apple.TheAppleSignIn.isAvailable(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator.adaptive();
                }
                if (!snapshot.hasData || (snapshot.data != true)) {
                  return Container();
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, bottom: 20),
                    child: apple.AppleSignInButton(
                        cornerRadius: 25.0,
                        type: apple.ButtonType.signIn,
                        style: isDarkMode
                            ? apple.ButtonStyle.white
                            : apple.ButtonStyle.black,
                        onPressed: () => onClickLogin('apple')),
                  );
                }
              },
            ),
            // Mobile authentication
            InkWell(
              onTap: onClickMobile,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Login with phone number',
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

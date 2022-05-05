import 'package:display/display.dart';
import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../../widgets/decorations/text_field_decoration.dart';
import '../../../constants/constants.dart';
import '../redirected/redirected.dart';
import 'model/login_model.dart';

/// This view contains a form and makes login requests to authentication
/// service.
class LoginView extends PreAuthenticationView<LoginModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  init(BuildContext context, LoginModel model) async {
    // Wait for redirect logic
    await super.init(context, model);

    // Only close loading widget if we are not redirecting
    if (!await shouldRedirect) {
      // Finished loading
      model.loading = false;
    }
  }

  @override
  Widget build(BuildContext context, LoginModel model) {
    // This function will show a progress widget while we wait for a login
    // request to go through the authentication service. This will show an alert
    // with an error message if there is an error or it will redirect the user
    // to the home view.
    loginClick(LoginMethod method) => showProgressUntil(
        context: context,
        message: 'Logging in, please wait...',
        showUntil: () => model.login(method),
        onDone: (result) {
          if (result != null) {
            showAlertDialog(context, 'Login Failed', result);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
          }
        });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        elevation: 0.0,
      ),
      body: Form(
        key: model.formKey,
        autovalidateMode: model.validate,
        child: ListView(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      color: Color(COLOR_PRIMARY),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 18.0),
                    validator: validateEmail,
                    onSaved: (val) => model.email = val,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color(COLOR_PRIMARY),
                    decoration: TextFieldInputDecoration('Email Address')),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    onSaved: (val) => model.password = val,
                    obscureText: true,
                    validator: validatePassword,
                    onFieldSubmitted: (_) => loginClick(LoginMethod.email),
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 18.0),
                    cursorColor: Color(COLOR_PRIMARY),
                    decoration: TextFieldInputDecoration('Password')),
              ),
            ),

            /// Forgot password text, navigates user to ResetPasswordScreen
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/resetPassword'),
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
                        primary: Color(COLOR_PRIMARY),
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BORDER_RADIUS,
                            side: BorderSide(color: Color(COLOR_PRIMARY))),
                      ),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                      onPressed: () => loginClick(LoginMethod.email))),
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
                        onPressed: () => loginClick(LoginMethod.apple)),
                  );
                }
              },
            ),
            // Mobile authentication
            InkWell(
              onTap: () => Navigator.pushNamed(context, '/mobileAuth'),
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

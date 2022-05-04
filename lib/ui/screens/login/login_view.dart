import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../../../constants/constants.dart';
import '../base_view.dart';
import 'model/login_model.dart';

class LoginView extends BaseView<LoginModel> {
  @override
  Widget build(BuildContext context, LoginModel model) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black),
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
                  validator: (val) => validateEmail(val),
                  onSaved: (val) => model.email = val,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Color(COLOR_PRIMARY),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    hintText: 'E-mail Address',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: Color(COLOR_PRIMARY), width: 2.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
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
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  onSaved: (val) => model.password = val,
                  obscureText: true,
                  validator: (val) => validatePassword(val),
                  onFieldSubmitted: (_) =>
                      loginClick(context, model, LoginMethod.email),
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 18.0),
                  cursorColor: Color(COLOR_PRIMARY),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    hintText: 'Password',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: Color(COLOR_PRIMARY), width: 2.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
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

            /// forgot password text, navigates user to ResetPasswordScreen
            /// and this is only visible when logging with email and password
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
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Color(COLOR_PRIMARY))),
                      ),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      onPressed: () =>
                          loginClick(context, model, LoginMethod.email))),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
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
                        style: Theme.of(context).brightness == Brightness.dark
                            ? apple.ButtonStyle.white
                            : apple.ButtonStyle.black,
                        onPressed: () =>
                            loginClick(context, model, LoginMethod.apple)),
                  );
                }
              },
            ),

            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/mobileAuth');
              },
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

  void loginClick(BuildContext context, LoginModel model, LoginMethod method) {
    showProgressUntil(
        context: context,
        message: 'Logging in, please wait...',
        showUntil: () => model.login(method),
        onDone: (result) async {
          if (result != null) {
            showAlertDialog(context, 'Login Failed', result);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
          }
        });
  }
}

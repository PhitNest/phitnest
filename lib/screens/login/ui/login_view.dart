import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../../../app.dart';

class LoginView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode validate;
  final void Function(String?) updateEmail;
  final void Function(String?) updatePassword;
  final void Function() clickLogin;
  final void Function() clickResetPassword;
  final void Function() clickPhone;
  final Future<bool> showApple;
  final void Function() clickApple;
  final void Function() clickFacebook;

  const LoginView(
      {Key? key,
      required this.formKey,
      required this.validate,
      required this.updateEmail,
      required this.updatePassword,
      required this.clickLogin,
      required this.clickResetPassword,
      required this.clickPhone,
      required this.showApple,
      required this.clickApple,
      required this.clickFacebook})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: DisplayUtils.isDarkMode
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: DisplayUtils.isDarkMode ? Colors.white : Colors.black),
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
                  validator: (val) => ValidationUtils.validateEmail(val),
                  onSaved: updateEmail,
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
                  onSaved: updatePassword,
                  obscureText: true,
                  validator: ValidationUtils.validatePassword,
                  onFieldSubmitted: (password) => clickLogin(),
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
                  onTap: clickResetPassword,
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
                      color:
                          DisplayUtils.isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                  onPressed: clickLogin,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                      color: DisplayUtils.isDarkMode
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, bottom: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton.icon(
                  label: Text(
                    'Facebook Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Color(FACEBOOK_BUTTON_COLOR),
                      ),
                    ),
                  ),
                  onPressed: clickFacebook,
                ),
              ),
            ),
            FutureBuilder<bool>(
              future: showApple,
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
                      style: DisplayUtils.isDarkMode
                          ? apple.ButtonStyle.white
                          : apple.ButtonStyle.black,
                      onPressed: clickApple,
                    ),
                  );
                }
              },
            ),

            InkWell(
              onTap: clickPhone,
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

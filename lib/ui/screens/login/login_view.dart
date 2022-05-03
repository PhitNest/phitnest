import 'package:phitnest/constants/constants.dart';
import 'package:phitnest/services/helper.dart';
import 'package:phitnest/ui/screens/base_view.dart';
import 'package:phitnest/ui/screens/login/model/login_model.dart';
import 'package:phitnest/ui/screens/phoneAuth/PhoneNumberInputScreen.dart';
import 'package:phitnest/ui/screens/resetPasswordScreen/ResetPasswordScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:validation/validation.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

class LoginScreen extends BaseView<LoginModel> {
  @override
  Widget build(BuildContext context, LoginModel model, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
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
                  'Sign In'.tr(),
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
                    hintText: 'E-mail Address'.tr(),
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
                  onFieldSubmitted: (password) => model.login(context),
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 18.0),
                  cursorColor: Color(COLOR_PRIMARY),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    hintText: 'Password'.tr(),
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
                  onTap: () => push(context, ResetPasswordScreen()),
                  child: Text(
                    'Forgot password?'.tr(),
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
                    'Log In'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode(context) ? Colors.black : Colors.white,
                    ),
                  ),
                  onPressed: () => model.login(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'OR'.tr(),
                  style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : Colors.black),
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
                      style: isDarkMode(context)
                          ? apple.ButtonStyle.white
                          : apple.ButtonStyle.black,
                      onPressed: () => model.loginWithApple(context),
                    ),
                  );
                }
              },
            ),

            InkWell(
              onTap: () {
                push(context, PhoneNumberInputScreen(login: true));
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Login with phone number'.tr(),
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

import 'package:device/device.dart';
import 'package:flutter/material.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../../common/textStyles/text_styles.dart';
import '../../common/widgets/widgets.dart';
import '../views.dart';

/// This view contains a form and makes login requests to authentication
/// service.
class SignInView extends BaseView {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode validate;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? Function(String? email) validateEmail;
  final String? Function(String? password) validatePassword;
  final Function(String method) onClickLogin;
  final Function() onClickResetPassword;
  final Function() onClickMobile;

  const SignInView(
      {required this.formKey,
      required this.emailController,
      required this.passwordController,
      required this.validate,
      required this.validateEmail,
      required this.validatePassword,
      required this.onClickLogin,
      required this.onClickResetPassword,
      required this.onClickMobile})
      : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackButtonAppBar(),
        body: Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: Form(
            key: formKey,
            autovalidateMode: validate,
            child: ListView(
              children: [
                Container(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Sign In',
                      style: HeadingTextStyle(size: TextSize.LARGE)),
                ),
                TextInputFormField(
                  key: Key("signIn_email"),
                  hint: 'Email Address',
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                TextInputFormField(
                  key: Key("signIn_password"),
                  hint: 'Password',
                  validator: validatePassword,
                  controller: passwordController,
                  hide: true,
                  onSubmit: () => onClickLogin('email'),
                ),

                /// Forgot password text, navigates user to ResetPasswordScreen
                Container(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onClickResetPassword,
                    child: Text(
                      'Forgot password?',
                      style: BodyTextStyle(
                          color: Colors.lightBlue,
                          weight: FontWeight.bold,
                          size: TextSize.MEDIUM,
                          letterSpacing: 1),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
                  child: StyledButton(
                    key: Key("signIn_submit"),
                    text: 'Sign In',
                    onClick: () => onClickLogin('email'),
                  ),
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
                        'Sign In with phone number',
                        style: BodyTextStyle(
                            color: Colors.lightBlue,
                            weight: FontWeight.bold,
                            size: TextSize.MEDIUM,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

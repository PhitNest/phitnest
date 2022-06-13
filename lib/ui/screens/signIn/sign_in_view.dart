import 'package:device/device.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/ui/common/widgetStyles/buttonStyles/button_styles.dart';
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
  final Function() onClickLogin;
  final Function() onClickResetPassword;
  // final Function() onClickMobile;

  const SignInView({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.validate,
    required this.validateEmail,
    required this.validatePassword,
    required this.onClickLogin,
    required this.onClickResetPassword,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // If keyboard is open, this will unfocus the keyboard(thus the keyboard will close on the screen)
          FocusManager.instance.primaryFocus?.unfocus();
          var val = Stopwatch();
          val.start();

          /// This ensures that there is no render overflow when the keyboard is open.
          /// Thus waiting for this value to be 0.
          while (WidgetsBinding.instance.window.viewInsets.bottom != 0.0) {
            await Future.delayed(Duration(milliseconds: 100));
            // Prevents potential infinite loop after 30 seconds. Unlikely to occur. Would be an error from the devices end
            // if this if-statement fired.
            if (val.elapsedMilliseconds >= 30000) {
              break;
            }
            continue;
          }
          ;
          val.stop();
          return true;
        },
        child: Scaffold(
          appBar: BackButtonAppBar(),
          body: Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: Form(
              key: formKey,
              autovalidateMode: validate,
              child: ListView(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * (1 / 150)),
                  Container(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Sign In',
                      style: HeadingTextStyle(
                          size: TextSize.HUGE, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * (1 / 50)),
                  TextInputFormField(
                    key: Key("signIn_email"),
                    hint: 'Email',
                    hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                  TextInputFormField(
                    key: Key("signIn_password"),
                    hint: 'Password',
                    hintStyle: BodyTextStyle(size: TextSize.MEDIUM),
                    validator: validatePassword,
                    controller: passwordController,
                    hide: true,
                    onSubmit: onClickLogin,
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
                            color: Color.fromARGB(255, 40, 157, 159),
                            weight: FontWeight.bold,
                            size: TextSize.MEDIUM,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: StyledButton(
                      key: Key("logIn_submit"),
                      text: 'Log In',
                      onClick: onClickLogin,
                      textColor: Colors.black,
                      buttonColor: Button_Styles.LIGHTCYAN,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(32.0),
                  //   child: Center(
                  //     child: Text(
                  //       'OR',
                  //       style: TextStyle(
                  //           color: isDarkMode ? Colors.white : Colors.black),
                  //     ),
                  //   ),
                  // ),
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
                              onPressed: onClickLogin),
                        );
                      }
                    },
                  ),
                  // Mobile authentication
                  // InkWell(
                  //   onTap: onClickMobile,
                  //   child: Center(
                  //     child: Padding(
                  //       padding: EdgeInsets.all(8.0),
                  //       child: Text(
                  //         'Login with phone number',
                  //         style: BodyTextStyle(
                  //             color: Color.fromARGB(255, 40, 157, 159),
                  //             weight: FontWeight.bold,
                  //             size: TextSize.MEDIUM,
                  //             letterSpacing: 1),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}

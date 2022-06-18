import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
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
  Widget build(BuildContext context) => Scaffold(
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
                    style: HeadingTextStyle(size: TextSize.HUGE),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * (1 / 50)),
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
                  onSubmit: (_) => onClickLogin(),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onClickResetPassword,
                    child: Text(
                      'Forgot password?',
                      style: BodyTextStyle(
                          color: COLOR_ACCENT,
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'OR',
                      style: BodyTextStyle(size: TextSize.LARGE),
                    ),
                  ),
                ),

                // Mobile authentication
                InkWell(
                  onTap: onClickMobile,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Login with phone number',
                        style: BodyTextStyle(
                            color: COLOR_ACCENT,
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
        ),
      );
}

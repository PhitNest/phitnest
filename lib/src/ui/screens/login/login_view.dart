import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';
import '../view.dart';

class LoginView extends ScreenView {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function() onPressedSignIn;
  final Function() onPressedForgotPassword;
  final Function() onPressedRegister;
  final GlobalKey<FormState> formKey;
  final String? Function(String? email) validateEmail;
  final String? Function(String? password) validatePassword;
  final AutovalidateMode autovalidateMode;

  LoginView({
    required this.emailController,
    required this.passwordController,
    required this.onPressedSignIn,
    required this.onPressedForgotPassword,
    required this.onPressedRegister,
    required this.autovalidateMode,
    required this.formKey,
    required this.validateEmail,
    required this.validatePassword,
  }) : super();

  @override
  bool showAppBar(BuildContext context) => false;

  @override
  Widget buildView(BuildContext context) => Column(
        children: [
          112.verticalSpace,
          LogoWidget(width: 72.w),
          26.verticalSpace,
          Text(
            'Phitnest is Better Together',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          54.verticalSpace,
          SizedBox(
            width: 291.w,
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  SizedBox(
                    height: 34.h,
                    child: TextInputField(
                      hint: 'Email',
                      validator: validateEmail,
                      inputAction: TextInputAction.next,
                      controller: emailController,
                    ),
                  ),
                  16.verticalSpace,
                  SizedBox(
                    height: 34.h,
                    child: TextInputField(
                      hint: 'Password',
                      validator: validatePassword,
                      inputAction: TextInputAction.done,
                      controller: passwordController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          34.verticalSpace,
          StyledButton(
            onPressed: onPressedSignIn,
            child: Text('SIGN IN'),
          ),
          Expanded(child: Container()),
          TextButton(
            onPressed: onPressedForgotPassword,
            child: Text(
              'FORGOT PASSWORD?',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
          TextButton(
            onPressed: onPressedRegister,
            child: Text(
              'REGISTER',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
          37.verticalSpace
        ],
      );
}

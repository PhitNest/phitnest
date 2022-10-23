import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class LoginView extends ScreenView {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function() onPressedSignIn;
  final Function() onPressedForgotPassword;
  final Function() onPressedRegister;

  @override
  bool get scrollable => true;

  LoginView({
    required this.emailController,
    required this.passwordController,
    required this.onPressedSignIn,
    required this.onPressedForgotPassword,
    required this.onPressedRegister,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                        hint: 'Email',
                        controller: emailController,
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                        hint: 'Password',
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
        ),
      );
}

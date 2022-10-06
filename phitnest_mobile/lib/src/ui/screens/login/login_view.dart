import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class LoginView extends ScreenView {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function() onSignIn;
  final Function() onForgotPassword;
  final Function() onRegister;

  LoginView({
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.onForgotPassword,
    required this.onRegister,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 23.62.h, top: 76.h),
                child: LogoWidget(width: 63.w),
              ),
              Text(
                'Phitnest is Better Together',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              64.verticalSpace,
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
              40.verticalSpace,
              StyledButton(
                onPressed: onSignIn,
                child: Text('SIGN IN'),
              ),
              93.verticalSpace,
              TextButton(
                onPressed: onForgotPassword,
                child: Text(
                  'FORGOT PASSWORD?',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              22.verticalSpace,
              TextButton(
                onPressed: onRegister,
                child: Text(
                  'REGISTER',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
}

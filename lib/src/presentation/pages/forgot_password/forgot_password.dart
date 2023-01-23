import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';
import '../../widgets/widgets.dart';

const kBackgroundColor = Color(0xFFF5F5F5);

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPassController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPassFocusNode;
  final VoidCallback onSubmit;

  const ForgotPasswordPage({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPassController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPassFocusNode,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: StyledBackButton(
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          backgroundColor: kBackgroundColor,
        ),
        body: SizedBox(
          width: 1.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.verticalSpace,
              Text(
                'Forgot the password?',
                style: theme.textTheme.headlineLarge,
              ),
              42.verticalSpace,
              Text(
                'We’ll send you an email to reset\nyour password.',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
              16.verticalSpace,
              SizedBox(
                width: 291.w,
                child: Column(
                  children: [
                    StyledUnderlinedTextField(
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      focusNode: emailFocusNode,
                    ),
                    StyledUnderlinedTextField(
                      hint: 'New Password',
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                    ),
                    StyledUnderlinedTextField(
                      hint: 'Confirm Password',
                      keyboardType: TextInputType.visiblePassword,
                      controller: confirmPassController,
                      focusNode: confirmPassFocusNode,
                    ),
                  ],
                ),
              ),

              30.verticalSpace,
              StyledButton(
                text: 'Submit',
                onPressed: () {},
              ),
              // StyledUnderlinedTextField(),
            ],
          ),
        ),
      );
}

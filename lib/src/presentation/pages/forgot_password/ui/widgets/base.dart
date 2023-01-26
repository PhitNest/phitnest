import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/theme.dart';
import '../../../../../common/validators.dart';
import '../../../../widgets/widgets.dart';

const kBackgroundColor = Color(0xFFF5F5F5);

abstract class ForgotPasswordBasePage extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPassController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPassFocusNode;
  final Widget child;
  final VoidCallback onSubmit;
  final AutovalidateMode autovalidateMode;
  final GlobalKey<FormState> formKey;

  const ForgotPasswordBasePage({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPassController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPassFocusNode,
    required this.child,
    required this.onSubmit,
    required this.autovalidateMode,
    required this.formKey,
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
              Form(
                autovalidateMode: autovalidateMode,
                key: formKey,
                child: SizedBox(
                  width: 291.w,
                  child: Column(
                    children: [
                      StyledUnderlinedTextField(
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        focusNode: emailFocusNode,
                        validator: (email) => validateEmail(email),
                      ),
                      StyledPasswordField(
                        hint: 'New Password',
                        textInputAction: TextInputAction.next,
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        validator: (pass) => validatePassword(pass),
                      ),
                      StyledPasswordField(
                        hint: 'Confirm Password',
                        textInputAction: TextInputAction.done,
                        controller: confirmPassController,
                        focusNode: confirmPassFocusNode,
                        validator: (confirmPass) => passwordController.text ==
                                confirmPassController.text
                            ? null
                            : "Password did not match",
                      ),
                    ],
                  ),
                ),
              ),
              30.verticalSpace,
              child
              // StyledUnderlinedTextField(),
            ],
          ),
        ),
      );
}

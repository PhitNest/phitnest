import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/theme.dart';
import '../../../../../common/validators.dart';
import '../../../../widgets/widgets.dart';

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
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Column(
              children: [
                40.verticalSpace,
                StyledBackButton(),
                30.verticalSpace,
                Text(
                  'Forgot the password?',
                  style: theme.textTheme.headlineLarge,
                ),
                30.verticalSpace,
                Text(
                  'We’ll send you an email to reset\nyour password.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge,
                ),
                20.verticalSpace,
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
                              : "Passwords do not match",
                          onFieldSubmitted: (_) => onSubmit(),
                        ),
                      ],
                    ),
                  ),
                ),
                30.verticalSpace,
                child,
                Spacer(),
              ],
            ),
          ),
        ),
      );
}

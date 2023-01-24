import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/assets.dart';
import '../../../../../common/theme.dart';
import '../../../../../common/validators.dart';
import '../../../../widgets/styled/styled.dart';

abstract class LoginPageBase extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final GlobalKey<FormState> formKey;
  final double keyboardHeight;
  final AutovalidateMode autovalidateMode;
  final VoidCallback onSubmit;
  final Widget child;
  final VoidCallback onPressedForgotPassword;
  final VoidCallback onPressedRegister;
  final Set<Tuple2<String, String>> invalidCredentials;

  const LoginPageBase({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.formKey,
    required this.keyboardHeight,
    required this.autovalidateMode,
    required this.onSubmit,
    required this.child,
    required this.onPressedForgotPassword,
    required this.onPressedRegister,
    required this.invalidCredentials,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        // Prevent overflow and allow drag to dismiss keyboard
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: 1.sh,
            child: Column(
              children: [
                double.infinity.horizontalSpace,
                (120 - keyboardHeight / 4).verticalSpace,
                Image.asset(
                  Assets.logo.path,
                  width: 61.59.w,
                ),
                25.verticalSpace,
                Text(
                  'PhitNest is Better Together',
                  style: theme.textTheme.headlineMedium,
                ),
                40.verticalSpace,
                SizedBox(
                  width: 291.w,
                  child: Form(
                    key: formKey,
                    autovalidateMode: autovalidateMode,
                    child: Column(
                      children: [
                        StyledUnderlinedTextField(
                          controller: emailController,
                          hint: 'Email',
                          errorMaxLines: 1,
                          focusNode: emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              validateEmail(value) ??
                              (invalidCredentials.any((credentials) =>
                                      credentials.value1 == value &&
                                      credentials.value2 ==
                                          passwordController.text)
                                  ? 'Invalid email/password'
                                  : null),
                        ),
                        StyledPasswordField(
                          controller: passwordController,
                          hint: 'Password',
                          focusNode: passwordFocusNode,
                          textInputAction: TextInputAction.done,
                          validator: (value) => validatePassword(value),
                          onFieldSubmitted: (value) => onSubmit(),
                        ),
                      ],
                    ),
                  ),
                ),
                16.verticalSpace,
                child,
                Spacer(),
                StyledUnderlinedTextButton(
                  text: 'FORGOT PASSWORD?',
                  onPressed: onPressedForgotPassword,
                ),
                StyledUnderlinedTextButton(
                  text: 'REGISTER',
                  onPressed: onPressedRegister,
                ),
                48.verticalSpace,
              ],
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';
import '../../../common/validators.dart';
import '../../widgets/widgets.dart';

class OnBoardingPageTwo extends StatelessWidget {
  final VoidCallback onPressedButton;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode autovalidateMode;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final String firstName;
  final Widget topSpacer;
  final Widget bottomSpacer;
  final Widget middleSpacer;

  const OnBoardingPageTwo({
    Key? key,
    required this.onPressedButton,
    required this.formKey,
    required this.autovalidateMode,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.firstName,
    required this.topSpacer,
    required this.bottomSpacer,
    required this.middleSpacer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          double.infinity.horizontalSpace,
          topSpacer,
          Text(
            "Hi, $firstName.\nLet's make an account.",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          middleSpacer,
          Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledUnderlinedTextField(
                  width: 291.w,
                  hint: 'Email',
                  controller: emailController,
                  validator: (value) => validateEmail(value),
                  textInputAction: TextInputAction.next,
                  focusNode: emailFocusNode,
                ),
                12.verticalSpace,
                StyledUnderlinedTextField(
                  width: 291.w,
                  hint: 'Password',
                  controller: passwordController,
                  validator: (value) => validatePassword(value),
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  focusNode: passwordFocusNode,
                ),
                12.verticalSpace,
                StyledUnderlinedTextField(
                  width: 291.w,
                  hint: 'Confirm password',
                  controller: confirmPasswordController,
                  onFieldSubmitted: (val) => onPressedButton(),
                  obscureText: true,
                  focusNode: confirmPasswordFocusNode,
                  validator: (value) =>
                      passwordController.text == confirmPasswordController.text
                          ? null
                          : "Passwords don't match",
                ),
              ],
            ),
          ),
          bottomSpacer,
          StyledButton(
            onPressed: onPressedButton,
            text: "NEXT",
          ),
        ],
      );
}

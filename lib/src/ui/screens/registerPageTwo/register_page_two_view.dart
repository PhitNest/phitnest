import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';

class RegisterPageTwoView extends StatelessWidget {
  final VoidCallback onPressedNext;
  final GlobalKey<FormState> formKey;
  final FormFieldValidator validateEmail;
  final FormFieldValidator validatePassword;
  final FormFieldValidator validateConfirmPassword;
  final AutovalidateMode autovalidateMode;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onTapEmail;
  final VoidCallback onTapPassword;
  final VoidCallback onTapConfirmPassword;
  final VoidCallback onPressedBack;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final FocusNode confirmPasswordFocus;
  final ScrollController scrollController;
  final String? initialErrorMessage;

  const RegisterPageTwoView({
    required this.scrollController,
    required this.formKey,
    required this.autovalidateMode,
    required this.emailController,
    required this.onPressedNext,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.validateEmail,
    required this.validatePassword,
    required this.validateConfirmPassword,
    required this.onTapEmail,
    required this.onTapPassword,
    required this.onTapConfirmPassword,
    required this.emailFocus,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    required this.onPressedBack,
    required this.initialErrorMessage,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        onPressedBack: onPressedBack,
        scrollController: scrollController,
        body: Column(
          children: [
            28.verticalSpace,
            Text(
              'Register',
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            35.verticalSpace,
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
                        onTap: onTapEmail,
                        validator: validateEmail,
                        controller: emailController,
                        focusNode: emailFocus,
                        inputAction: TextInputAction.next,
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                        hint: 'Password',
                        validator: validatePassword,
                        onTap: onTapPassword,
                        controller: passwordController,
                        focusNode: passwordFocus,
                        hide: true,
                        inputAction: TextInputAction.next,
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                        hint: "Confirm Password",
                        validator: validateConfirmPassword,
                        onTap: onTapConfirmPassword,
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocus,
                        hide: true,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: initialErrorMessage != null,
              child: Container(
                padding: EdgeInsets.only(top: 40.h),
                width: 0.9.sw,
                child: Text(
                  initialErrorMessage ?? '',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
            40.verticalSpace,
            StyledButton(
              onPressed: onPressedNext,
              child: Text('NEXT'),
            ),
            60.verticalSpace,
          ],
        ),
      );
}

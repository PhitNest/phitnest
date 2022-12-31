import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';

class LoadingView extends _BaseWidget {
  LoadingView({
    required super.autovalidateMode,
    required super.emailController,
    required super.passwordController,
    required super.formKey,
    required super.validateEmail,
    required super.validatePassword,
    required super.scrollController,
    required super.focusPassword,
    required super.focusEmail,
    required super.onTapEmail,
    required super.onTapPassword,
    required super.confirmPasswordController,
    required super.focusConfirmPassword,
    required super.onTapConfirmPassword,
    required super.validateConfirmPassword,
  }) : super(
          child: CircularProgressIndicator(),
        );
}

class ErrorView extends _BaseWidget {
  final String message;
  final VoidCallback onPressedRetry;

  ErrorView({
    required this.message,
    required this.onPressedRetry,
    required super.scrollController,
    required super.onTapEmail,
    required super.formKey,
    required super.validateEmail,
    required super.validatePassword,
    required super.validateConfirmPassword,
    required super.emailController,
    required super.passwordController,
    required super.confirmPasswordController,
    required super.focusEmail,
    required super.focusPassword,
    required super.focusConfirmPassword,
    required super.autovalidateMode,
    required super.onTapConfirmPassword,
    required super.onTapPassword,
  }) : super(
          child: Column(
            children: [
              Text(
                message,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.errorColor,
                ),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              StyledButton(
                onPressed: onPressedRetry,
                child: Text('RETRY'),
              ),
            ],
          ),
        );
}

class InitialView extends _BaseWidget {
  final VoidCallback onPressedSubmit;

  InitialView({
    required this.onPressedSubmit,
    required super.scrollController,
    required super.onTapEmail,
    required super.formKey,
    required super.validateEmail,
    required super.validatePassword,
    required super.validateConfirmPassword,
    required super.emailController,
    required super.passwordController,
    required super.confirmPasswordController,
    required super.focusEmail,
    required super.focusPassword,
    required super.focusConfirmPassword,
    required super.autovalidateMode,
    required super.onTapConfirmPassword,
    required super.onTapPassword,
  }) : super(
          child: StyledButton(
            onPressed: onPressedSubmit,
            child: Text('SUBMIT'),
          ),
        );
}

class _BaseWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Widget child;
  final ScrollController scrollController;
  final FocusNode focusEmail;
  final FocusNode focusPassword;
  final FocusNode focusConfirmPassword;
  final VoidCallback onTapEmail;
  final VoidCallback onTapPassword;
  final VoidCallback onTapConfirmPassword;
  final AutovalidateMode autovalidateMode;
  final GlobalKey<FormState> formKey;
  final FormFieldValidator validateEmail;
  final FormFieldValidator validatePassword;
  final FormFieldValidator validateConfirmPassword;

  const _BaseWidget({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.child,
    required this.scrollController,
    required this.focusEmail,
    required this.focusPassword,
    required this.focusConfirmPassword,
    required this.onTapEmail,
    required this.onTapPassword,
    required this.onTapConfirmPassword,
    required this.autovalidateMode,
    required this.formKey,
    required this.validateEmail,
    required this.validatePassword,
    required this.validateConfirmPassword,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        scrollController: scrollController,
        body: Column(
          children: [
            30.verticalSpace,
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
            56.verticalSpace,
            SizedBox(
              width: 291.w,
              child: Form(
                key: formKey,
                autovalidateMode: autovalidateMode,
                child: SizedBox(
                  child: Column(
                    children: [
                      TextInputField(
                        focusNode: focusEmail,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        validator: validateEmail,
                        onTap: onTapEmail,
                        hint: 'Email',
                      ),
                      TextInputField(
                        focusNode: focusPassword,
                        controller: passwordController,
                        validator: validatePassword,
                        hide: true,
                        inputAction: TextInputAction.next,
                        onTap: onTapPassword,
                        hint: 'New Password',
                      ),
                      TextInputField(
                        focusNode: focusConfirmPassword,
                        controller: confirmPasswordController,
                        validator: validateConfirmPassword,
                        hide: true,
                        onTap: onTapConfirmPassword,
                        hint: 'Confirm Password',
                      ),
                      30.verticalSpace,
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

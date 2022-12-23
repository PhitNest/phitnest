import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';

class InitialView extends StatelessWidget {
  const InitialView() : super();

  @override
  Widget build(BuildContext context) =>
      BetterScaffold(body: Center(child: CircularProgressIndicator()));
}

class LoadingView extends _BaseWidget {
  final VoidCallback onPressedForgotPassword;
  final VoidCallback onPressedRegister;

  LoadingView({
    required this.onPressedRegister,
    required this.onPressedForgotPassword,
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
  }) : super(
          child: Column(
            children: [
              CircularProgressIndicator(),
              Spacer(),
              TextButtonWidget(
                onPressed: onPressedForgotPassword,
                text: 'FORGOT PASSWORD?',
              ),
              TextButtonWidget(
                onPressed: onPressedRegister,
                text: 'REGISTER',
              ),
              37.verticalSpace
            ],
          ),
        );
}

class ErrorView extends LoadedView {
  final String errorMessage;

  ErrorView({
    required this.errorMessage,
    required super.autovalidateMode,
    required super.emailController,
    required super.passwordController,
    required super.onPressedSignIn,
    required super.onPressedForgotPassword,
    required super.onPressedRegister,
    required super.formKey,
    required super.validateEmail,
    required super.validatePassword,
    required super.scrollController,
    required super.focusPassword,
    required super.focusEmail,
    required super.onTapEmail,
    required super.onTapPassword,
  }) : super(
          child: Column(
            children: [
              Text(
                errorMessage,
                style: theme.textTheme.labelLarge!
                    .copyWith(color: theme.errorColor),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              StyledButton(
                onPressed: onPressedSignIn,
                child: Text('RETRY'),
              ),
              Spacer(),
              TextButtonWidget(
                onPressed: onPressedForgotPassword,
                text: 'FORGOT PASSWORD?',
              ),
              TextButtonWidget(
                onPressed: onPressedRegister,
                text: 'REGISTER',
              ),
              37.verticalSpace
            ],
          ),
        );
}

class LoadedView extends _BaseWidget {
  final VoidCallback onPressedSignIn;
  final VoidCallback onPressedForgotPassword;
  final VoidCallback onPressedRegister;

  LoadedView({
    required this.onPressedSignIn,
    required this.onPressedForgotPassword,
    required this.onPressedRegister,
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
    Widget? child,
  }) : super(
          child: child ??
              Column(
                children: [
                  StyledButton(
                    onPressed: onPressedSignIn,
                    child: Text('SIGN IN'),
                  ),
                  Spacer(),
                  TextButtonWidget(
                    onPressed: onPressedForgotPassword,
                    text: 'FORGOT PASSWORD?',
                  ),
                  TextButtonWidget(
                    onPressed: onPressedRegister,
                    text: 'REGISTER',
                  ),
                  37.verticalSpace
                ],
              ),
        );
}

class _BaseWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final FormFieldValidator validateEmail;
  final FormFieldValidator validatePassword;
  final AutovalidateMode autovalidateMode;
  final ScrollController scrollController;
  final FocusNode focusPassword;
  final FocusNode focusEmail;
  final VoidCallback onTapEmail;
  final VoidCallback onTapPassword;
  final Widget child;

  const _BaseWidget({
    required this.emailController,
    required this.passwordController,
    required this.autovalidateMode,
    required this.formKey,
    required this.validateEmail,
    required this.validatePassword,
    required this.scrollController,
    required this.focusPassword,
    required this.focusEmail,
    required this.onTapEmail,
    required this.onTapPassword,
    required this.child,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        scrollController: scrollController,
        body: Column(
          children: [
            112.verticalSpace,
            LogoWidget(
              width: 72.w,
            ),
            26.verticalSpace,
            Text(
              'Phitnest is Better Together',
              style: theme.textTheme.headlineMedium,
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
                      height: 40.h,
                      child: TextInputField(
                        hint: 'Email',
                        onTap: onTapEmail,
                        focusNode: focusEmail,
                        validator: validateEmail,
                        inputAction: TextInputAction.next,
                        controller: emailController,
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                      height: 40.h,
                      child: TextInputField(
                        hint: 'Password',
                        onTap: onTapPassword,
                        focusNode: focusPassword,
                        hide: true,
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
            Expanded(child: child),
          ],
        ),
      );
}

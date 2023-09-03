import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../register.dart';

final class RegisterAccountInfoPage extends StatelessWidget {
  final RegisterControllers controllers;
  final void Function() onSubmit;

  const RegisterAccountInfoPage({
    super.key,
    required this.controllers,
    required this.onSubmit,
  }) : super();

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              120.verticalSpace,
              Text(
                'Let\'s create your account!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              42.verticalSpace,
              StyledUnderlinedTextField(
                hint: 'Your email address',
                controller: controllers.emailController,
                validator: EmailValidator.validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              24.verticalSpace,
              StyledPasswordField(
                hint: 'Password',
                controller: controllers.passwordController,
                validator: validatePassword,
                textInputAction: TextInputAction.next,
              ),
              24.verticalSpace,
              StyledPasswordField(
                hint: 'Confirm password',
                validator: (value) =>
                    value == controllers.passwordController.text
                        ? null
                        : 'Passwords do not match',
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => onSubmit(),
              ),
              32.verticalSpace,
              ElevatedButton(
                onPressed: onSubmit,
                child: Text(
                  'SUBMIT',
                  style: theme.textTheme.bodySmall,
                ),
              )
            ],
          ),
        ),
      );
}

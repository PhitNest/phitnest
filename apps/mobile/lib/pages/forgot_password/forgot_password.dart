import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../widgets/widgets.dart';
import '../verification/verification.dart';

part 'bloc.dart';

final class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: _forgotPasswordForm(
            (context, controllers, submit) => LoaderConsumer(
              listener: (context, loaderState) =>
                  _handleStateChanged(context, controllers, loaderState),
              builder: (context, loaderState) {
                final formBloc = context.formBloc<ForgotPasswordControllers>();
                return PageView(
                  controller: controllers.pageController,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        64.verticalSpace,
                        Text(
                          'Forgot Password?',
                          style: theme.textTheme.bodyLarge,
                        ),
                        32.verticalSpace,
                        Text(
                          'Enter your email address',
                          style: theme.textTheme.bodyMedium,
                        ),
                        16.verticalSpace,
                        StyledUnderlinedTextField(
                          hint: 'Email',
                          controller: controllers.emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              formBloc.formKey.currentState!.validate()
                                  ? controllers.pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    )
                                  : {},
                          validator: EmailValidator.validateEmail,
                        ),
                        23.verticalSpace,
                        StyledOutlineButton(
                          onPress: () => controllers.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          text: 'NEXT',
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        64.verticalSpace,
                        Text(
                          'Forgot Password?',
                          style: theme.textTheme.bodyLarge,
                        ),
                        32.verticalSpace,
                        Text(
                          'Enter your new password',
                          style: theme.textTheme.bodyMedium,
                        ),
                        16.verticalSpace,
                        StyledPasswordField(
                          hint: 'New Password',
                          controller: controllers.newPasswordController,
                          textInputAction: TextInputAction.next,
                          validator: validatePassword,
                        ),
                        16.verticalSpace,
                        StyledPasswordField(
                          hint: 'Confirm Password',
                          controller: controllers.confirmPasswordController,
                          textInputAction: TextInputAction.done,
                          validator: (pass) =>
                              validatePassword(pass) ??
                              (pass != controllers.newPasswordController.text
                                  ? 'Passwords do not match'
                                  : null),
                          onFieldSubmitted: (_) => submit(
                              controllers.emailController.text, loaderState),
                        ),
                        23.verticalSpace,
                        Center(
                          child: switch (loaderState) {
                            LoaderLoadingState() =>
                              const CircularProgressIndicator(),
                            _ => ElevatedButton(
                                onPressed: () => submit(
                                    controllers.emailController.text,
                                    loaderState),
                                child: Text(
                                  'RESET PASSWORD',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
}

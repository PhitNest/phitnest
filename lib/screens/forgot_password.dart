import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

final class ForgotPasswordControllers extends FormControllers {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final pageController = PageController();

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    pageController.dispose();
  }
}

typedef ForgotPasswordFormBloc = FormBloc<ForgotPasswordControllers>;
typedef ForgotPasswordFormConsumer = FormConsumer<ForgotPasswordControllers>;
typedef ForgotPasswordLoaderBloc
    = LoaderBloc<String, SendForgotPasswordResponse>;
typedef ForgotPasswordLoaderConsumer
    = LoaderConsumer<String, SendForgotPasswordResponse>;

extension on BuildContext {
  ForgotPasswordFormBloc get forgotPasswordFormBloc => BlocProvider.of(this);
  ForgotPasswordLoaderBloc get forgotPasswordLoaderBloc => loader();
}

final class ForgotPasswordScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const ForgotPasswordScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ForgotPasswordFormBloc(
                ForgotPasswordControllers(),
              ),
            ),
            BlocProvider(
              create: (_) => ForgotPasswordLoaderBloc(
                load: (email) => sendForgotPasswordRequest(
                  email: email,
                  apiInfo: apiInfo,
                ),
              ),
            ),
          ],
          child: ForgotPasswordFormConsumer(
            listener: (context, formState) {},
            builder: (context, formState) => Form(
              key: context.forgotPasswordFormBloc.formKey,
              autovalidateMode: formState.autovalidateMode,
              child: PageView(
                children: [
                  Column(
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
                        controller: context
                            .forgotPasswordFormBloc.controllers.emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => context
                            .forgotPasswordFormBloc.controllers.pageController
                            .nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                        validator: EmailValidator.validateEmail,
                      ),
                    ],
                  ),
                  ForgotPasswordLoaderConsumer(
                    listener: (context, loaderState) {},
                    builder: (context, loaderState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          controller: context.forgotPasswordFormBloc.controllers
                              .newPasswordController,
                          textInputAction: TextInputAction.next,
                          validator: validatePassword,
                        ),
                        16.verticalSpace,
                        StyledPasswordField(
                          hint: 'Confirm Password',
                          controller: context.forgotPasswordFormBloc.controllers
                              .newPasswordController,
                          textInputAction: TextInputAction.done,
                          validator: (pass) =>
                              validatePassword(pass) ??
                              (pass !=
                                      context.forgotPasswordFormBloc.controllers
                                          .newPasswordController.text
                                  ? 'Passwords do not match'
                                  : null),
                          onFieldSubmitted: (_) => switch (loaderState) {
                            LoaderLoadingState() => {},
                            _ => context.forgotPasswordFormBloc.submit(
                                onAccept: () =>
                                    context.forgotPasswordLoaderBloc.add(
                                  LoaderLoadEvent(
                                    context.forgotPasswordFormBloc.controllers
                                        .emailController.text,
                                  ),
                                ),
                              )
                          },
                        ),
                        23.verticalSpace,
                        Center(
                          child: switch (loaderState) {
                            LoaderLoadingState() =>
                              const CircularProgressIndicator(),
                            _ => ElevatedButton(
                                onPressed: () =>
                                    context.forgotPasswordFormBloc.submit(
                                  onAccept: () =>
                                      context.forgotPasswordLoaderBloc.add(
                                    LoaderLoadEvent(
                                      context.forgotPasswordFormBloc.controllers
                                          .emailController.text,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'RESET PASSWORD',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils.dart';
import '../../../common/validators.dart';
import '../../../repositories/repositories.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import './forgot_password_state.dart';
import 'forgot_password_view.dart';

class ForgotPasswordProvider
    extends ScreenProvider<ForgotPasswordCubit, ForgotPasswordState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  late final FocusNode focusEmail = FocusNode()
    ..addListener(
      () {
        if (focusEmail.hasFocus) {
          scrollToEmail();
        }
      },
    );
  late final FocusNode focusPassword = FocusNode()
    ..addListener(
      () {
        if (focusPassword.hasFocus) {
          scrollToPassword();
        }
      },
    );
  late final FocusNode focusConfirmPassword = FocusNode()
    ..addListener(
      () {
        if (focusConfirmPassword.hasFocus) {
          scrollToConfirmPassword();
        }
      },
    );

  ForgotPasswordProvider() : super();

  void scrollToEmail() => scroll(scrollController, 40.h);

  void scrollToPassword() => scroll(scrollController, 60.h);

  void scrollToConfirmPassword() => scroll(scrollController, 80.h);

  void onPressedSubmit(ForgotPasswordCubit cubit) {
    focusConfirmPassword.unfocus();
    focusPassword.unfocus();
    focusEmail.unfocus();
    if (formKey.currentState!.validate()) {
      cubit.transitionToLoading();
    } else {
      cubit.enableAutovalidateMode();
    }
  }

  @override
  Future<void> listener(
    BuildContext context,
    ForgotPasswordCubit cubit,
    ForgotPasswordState state,
  ) async {
    if (state is LoadingState) {
      if (emailController.text.trim() == memoryCacheRepo.email &&
          memoryCacheRepo.triedConfirmRegister) {
        confirmRegisterUseCase.resendConfirmation(memoryCacheRepo.email!).then(
              (failure) => failure != null
                  ? cubit.transitionToError(failure.message)
                  : Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                        builder: (context) => ConfirmEmailProvider(
                          email: memoryCacheRepo.email!,
                          confirmVerification: (code, email) =>
                              confirmRegisterUseCase.confirmRegister(
                            email,
                            code,
                          ),
                          resendConfirmation: (email) =>
                              confirmRegisterUseCase.resendConfirmation(
                            email,
                          ),
                        ),
                      ),
                      (_) => false,
                    ),
            );
      } else {
        forgotPasswordUseCase.forgotPassword(emailController.text.trim()).then(
              (failure) => failure != null
                  ? cubit.transitionToError(failure.message)
                  : Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                        builder: (context) => ConfirmEmailProvider(
                          email: emailController.text.trim(),
                          confirmVerification: (code, email) =>
                              forgotPasswordUseCase.resetPassword(
                            email,
                            code,
                            passwordController.text,
                          ),
                          resendConfirmation: (email) =>
                              forgotPasswordUseCase.forgotPassword(email),
                        ),
                      ),
                      (_) => false,
                    ),
            );
      }
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ForgotPasswordCubit cubit,
    ForgotPasswordState state,
  ) {
    if (state is LoadingState) {
      return LoadingView(
        autovalidateMode: state.autovalidateMode,
        formKey: formKey,
        emailController: emailController,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
        focusEmail: focusEmail,
        focusPassword: focusPassword,
        focusConfirmPassword: focusConfirmPassword,
        scrollController: scrollController,
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        validateConfirmPassword: (value) =>
            value == passwordController.text ? null : 'Passwords do not match',
        onTapEmail: () => onTappedTextField(scrollToEmail),
        onTapPassword: () => onTappedTextField(scrollToPassword),
        onTapConfirmPassword: () => onTappedTextField(scrollToConfirmPassword),
      );
    } else if (state is InitialState) {
      return InitialView(
        autovalidateMode: state.autovalidateMode,
        formKey: formKey,
        emailController: emailController,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
        focusEmail: focusEmail,
        focusPassword: focusPassword,
        focusConfirmPassword: focusConfirmPassword,
        scrollController: scrollController,
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        validateConfirmPassword: (value) =>
            value == passwordController.text ? null : 'Passwords do not match',
        onTapEmail: () => onTappedTextField(scrollToEmail),
        onTapPassword: () => onTappedTextField(scrollToPassword),
        onTapConfirmPassword: () => onTappedTextField(scrollToConfirmPassword),
        onPressedSubmit: () => onPressedSubmit(cubit),
      );
    } else if (state is ErrorState) {
      return ErrorView(
        autovalidateMode: state.autovalidateMode,
        formKey: formKey,
        emailController: emailController,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
        focusEmail: focusEmail,
        focusPassword: focusPassword,
        focusConfirmPassword: focusConfirmPassword,
        scrollController: scrollController,
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        validateConfirmPassword: (value) =>
            value == passwordController.text ? null : 'Passwords do not match',
        onTapEmail: () => onTappedTextField(scrollToEmail),
        onTapPassword: () => onTappedTextField(scrollToPassword),
        onTapConfirmPassword: () => onTappedTextField(scrollToConfirmPassword),
        message: state.errorMessage,
        onPressedRetry: () => onPressedSubmit(cubit),
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  ForgotPasswordCubit buildCubit() => ForgotPasswordCubit();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    focusEmail.dispose();
    focusPassword.dispose();
    focusConfirmPassword.dispose();
    scrollController.dispose();
    super.dispose();
  }
}

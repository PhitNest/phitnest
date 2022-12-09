import 'package:flutter/material.dart';

import '../../../common/validators.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'login_state.dart';
import 'login_view.dart';

class LoginProvider extends ScreenProvider<LoginState, LoginView> {
  @override
  Future<void> init(BuildContext context, LoginState state) =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => Navigator.of(context).pushAndRemoveUntil(
                NoAnimationMaterialPageRoute(
                  builder: (context) => ExploreProvider(),
                ),
                (_) => false,
              ),
              (failure) {},
            ),
          );

  const LoginProvider() : super();

  @override
  LoginView build(BuildContext context, LoginState state) => LoginView(
        scrollController: state.scrollController,
        emailController: state.emailController,
        loading: state.loading,
        passwordController: state.passwordController,
        onPressedSignIn: () {
          state.focusEmail.unfocus();
          state.focusPassword.unfocus();
          if (!state.formKey.currentState!.validate()) {
            state.validateMode = AutovalidateMode.always;
          } else {
            state.loading = true;
            state.errorMessage = null;
            loginUseCase
                .login(
                    email: state.emailController.text,
                    password: state.passwordController.text)
                .then(
              (either) {
                state.loading = false;
                return either.fold(
                  (session) {
                    if (!state.disposed) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        NoAnimationMaterialPageRoute(
                          builder: (context) => ExploreProvider(),
                        ),
                        (_) => false,
                      );
                    }
                  },
                  (failure) => state.errorMessage = failure.message,
                );
              },
            );
          }
        },
        focusEmail: state.focusEmail,
        errorMessage: state.errorMessage,
        focusPassword: state.focusPassword,
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        autovalidateMode: state.validateMode,
        onTapEmail: () => Future.delayed(
          const Duration(milliseconds: 600),
          () => state.onFocusEmail(true),
        ),
        onTapPassword: () => Future.delayed(
          const Duration(milliseconds: 600),
          () => state.onFocusPassword(true),
        ),
        formKey: state.formKey,
        onPressedForgotPassword: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => ForgotPasswordProvider(),
          ),
        ),
        onPressedRegister: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => RegisterPageOneProvider(),
          ),
        ),
      );

  @override
  LoginState buildState() => LoginState();
}

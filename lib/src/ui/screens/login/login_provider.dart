import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/validators.dart';
import '../../../repositories/repositories.dart';
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
  Widget buildLoading(BuildContext context, LoginState state) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

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
                    email: state.emailController.text.trim(),
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
                  (failure) {
                    if (failure.message == "User is not confirmed.") {
                      Navigator.push(
                        context,
                        NoAnimationMaterialPageRoute(
                          builder: (context) => ConfirmEmailProvider(
                            onPressedBack: () => Navigator.pop(context),
                            email: state.emailController.text.trim(),
                            password: state.passwordController.text,
                            confirmVerification:
                                confirmRegisterUseCase.confirmRegister,
                            resendConfirmation: () =>
                                confirmRegisterUseCase.resendConfirmation(
                              state.emailController.text.trim(),
                            ),
                          ),
                        ),
                      );
                    }
                    state.errorMessage = failure.message;
                  },
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
            builder: (context) => RequestLocationProvider(
              onFoundUsersGym: (context, location, gym) => Navigator.push(
                context,
                NoAnimationMaterialPageRoute(
                  builder: (context) => RegisterPageOneProvider(),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  LoginState buildState() => LoginState();
}

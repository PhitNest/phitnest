import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils.dart';
import '../../../common/validators.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'login_state.dart';
import 'login_view.dart';

class LoginProvider extends ScreenProvider<LoginCubit, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  late final FocusNode emailFocus = FocusNode()
    ..addListener(
      () {
        if (emailFocus.hasFocus) {
          scrollToEmail();
        }
      },
    );
  late final FocusNode passwordFocus = FocusNode()
    ..addListener(
      () {
        if (passwordFocus.hasFocus) {
          scrollToPassword();
        }
      },
    );

  void scrollToEmail() => scroll(scrollController, 20.h);

  void scrollToPassword() => scroll(scrollController, 40.h);

  LoginProvider() : super();

  @override
  Future<void> listener(
    BuildContext context,
    LoginCubit cubit,
    LoginState state,
  ) async {
    if (state is InitialState) {
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => Navigator.of(context).pushAndRemoveUntil(
                NoAnimationMaterialPageRoute(
                  builder: (context) => ExploreProvider(),
                ),
                (_) => false,
              ),
              (failure) => cubit.transitionToLoaded(),
            ),
          );
    } else if (state is LoadingState) {
      loginUseCase
          .login(
            email: emailController.text.trim(),
            password: passwordController.text,
          )
          .then(
            (either) => either.fold(
              (session) => Navigator.pushAndRemoveUntil(
                context,
                NoAnimationMaterialPageRoute(
                  builder: (context) => ExploreProvider(),
                ),
                (_) => false,
              ),
              (failure) => cubit.transitionToError(failure.message),
            ),
          );
    }
  }

  @override
  Widget builder(
    BuildContext context,
    LoginCubit cubit,
    LoginState state,
  ) {
    if (state is LoadingState) {
      return LoadingView(
        autovalidateMode: state.autovalidateMode,
        emailController: emailController,
        passwordController: passwordController,
        onPressedRegister: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => RegisterPageOneProvider(),
          ),
        ),
        onPressedForgotPassword: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => ForgotPasswordProvider(),
          ),
        ),
        onTapEmail: () => onTappedTextField(scrollToEmail),
        onTapPassword: () => onTappedTextField(scrollToPassword),
        formKey: formKey,
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        scrollController: scrollController,
        focusEmail: emailFocus,
        focusPassword: passwordFocus,
      );
    } else if (state is ErrorState) {
      return ErrorView(
        autovalidateMode: state.autovalidateMode,
        emailController: emailController,
        passwordController: passwordController,
        onPressedSignIn: () {
          if (formKey.currentState!.validate()) {
            emailFocus.unfocus();
            passwordFocus.unfocus();
            cubit.transitionToLoading();
          } else {
            cubit.enableAutovalidateMode();
          }
        },
        onPressedRegister: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => RegisterPageOneProvider(),
          ),
        ),
        onPressedForgotPassword: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => ForgotPasswordProvider(),
          ),
        ),
        onTapEmail: () => onTappedTextField(scrollToEmail),
        onTapPassword: () => onTappedTextField(scrollToPassword),
        formKey: formKey,
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        scrollController: scrollController,
        focusEmail: emailFocus,
        focusPassword: passwordFocus,
        errorMessage: state.message,
      );
    } else if (state is LoadedState) {
      return LoadedView(
        autovalidateMode: state.autovalidateMode,
        emailController: emailController,
        passwordController: passwordController,
        onPressedRegister: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => RegisterPageOneProvider(),
          ),
        ),
        onPressedForgotPassword: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => ForgotPasswordProvider(),
          ),
        ),
        onTapEmail: () => onTappedTextField(scrollToEmail),
        onTapPassword: () => onTappedTextField(scrollToPassword),
        formKey: formKey,
        onPressedSignIn: () {
          if (formKey.currentState!.validate()) {
            cubit.transitionToLoading();
          } else {
            cubit.enableAutovalidateMode();
          }
        },
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        scrollController: scrollController,
        focusEmail: emailFocus,
        focusPassword: passwordFocus,
      );
    } else if (state is InitialState) {
      return const InitialView();
    } else {
      throw Exception('Invalid state: $state');
    }
  }

  @override
  LoginCubit buildCubit() => LoginCubit();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    scrollController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
}

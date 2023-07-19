import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api.dart';
import '../bloc/form.dart';
import '../bloc/loader.dart';
import '../cognito/cognito.dart';

final class LoginControllers extends FormControllers {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

typedef LoginFormBloc = FormBloc<LoginControllers>;
typedef LoginFormConsumer = FormConsumer<LoginControllers>;
typedef LoginLoaderBloc = LoaderBloc<LoginParams, LoginResponse>;
typedef LoginLoaderConsumer = LoaderConsumer<LoginParams, LoginResponse>;

extension GetLoginBlocs on BuildContext {
  LoginFormBloc get loginFormBloc => BlocProvider.of(this);
  LoginLoaderBloc get loginLoaderBloc => loader();
}

final class LoginProvider extends StatelessWidget {
  final ApiInfo apiInfo;

  final Widget Function(
    BuildContext context,
    AutovalidateMode validationMode,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    Widget Function({
      required Widget Function(BuildContext, LoaderState<LoginResponse>)
          builder,
      required void Function(BuildContext, LoaderState<LoginResponse>) listener,
    }) consumer,
    void Function() submit,
  ) formBuilder;

  void submit(BuildContext context) {
    final formBloc = context.loginFormBloc;
    formBloc.submit(
      onAccept: () {
        context.loginLoaderBloc.add(
          LoaderLoadEvent(
            LoginParams(
              email: formBloc.controllers.emailController.text,
              password: formBloc.controllers.passwordController.text,
            ),
          ),
        );
      },
    );
  }

  const LoginProvider({
    required this.apiInfo,
    required this.formBuilder,
  }) : super();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LoginFormBloc(LoginControllers()),
          ),
          BlocProvider(
            create: (_) => LoginLoaderBloc(
              load: (params) => login(
                params: params,
                apiInfo: apiInfo,
              ),
            ),
          ),
        ],
        child: LoginFormConsumer(
          listener: (context, state) {},
          builder: (context, state) {
            final formBloc = context.loginFormBloc;
            return formBuilder(
              context,
              state.autovalidateMode,
              formBloc.formKey,
              formBloc.controllers.emailController,
              formBloc.controllers.passwordController,
              ({required builder, required listener}) => LoginLoaderConsumer(
                builder: builder,
                listener: listener,
              ),
              () => submit(context),
            );
          },
        ),
      );
}

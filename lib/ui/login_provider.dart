import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api.dart';
import '../bloc/loader.dart';
import '../cognito/cognito.dart';

final class LoginFormRejectedEvent extends Equatable {
  const LoginFormRejectedEvent() : super();

  @override
  List<Object?> get props => [];
}

final class LoginState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const LoginState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}

final class LoginBloc extends Bloc<LoginFormRejectedEvent, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginBloc()
      : super(
          const LoginState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<LoginFormRejectedEvent>(
      (event, emit) => emit(
        const LoginState(
          autovalidateMode: AutovalidateMode.always,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

final class LoginProvider extends StatelessWidget {
  final ApiInfo apiInfo;

  final Widget Function(
    BuildContext context,
    LoginState screenState,
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
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    if (loginBloc.formKey.currentState!.validate()) {
      context.loader<LoginParams, LoginResponse>().add(
            LoaderLoadEvent(
              LoginParams(
                email: loginBloc.emailController.text,
                password: loginBloc.passwordController.text,
              ),
            ),
          );
    } else {
      loginBloc.add(const LoginFormRejectedEvent());
    }
  }

  const LoginProvider({
    required this.apiInfo,
    required this.formBuilder,
  }) : super();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LoaderBloc<LoginParams, LoginResponse>(
              load: (params) => login(
                apiInfo: apiInfo,
                params: params,
              ),
            ),
          ),
          BlocProvider(
            create: (_) => LoginBloc(),
          ),
        ],
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {},
          builder: (context, state) {
            final loginBloc = BlocProvider.of<LoginBloc>(context);
            return formBuilder(
              context,
              state,
              loginBloc.formKey,
              loginBloc.emailController,
              loginBloc.passwordController,
              ({required builder, required listener}) =>
                  LoaderConsumer<LoginParams, LoginResponse>(
                builder: builder,
                listener: listener,
              ),
              () => submit(context),
            );
          },
        ),
      );
}

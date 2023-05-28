import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

extension LoginBlocGetter on BuildContext {
  LoginBloc get loginBloc => BlocProvider.of(this);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginBloc()
      : super(
          const LoginInitialState(
            autovalidateMode: AutovalidateMode.disabled,
            loginButtonState: LoginButtonState.enabled,
          ),
        ) {
    on<LoginFormAcceptedEvent>(
      (event, emit) {
        emit(
          switch (state) {
            LoginInitialState(autovalidateMode: final autovalidateMode) =>
              LoginInitialState(
                autovalidateMode: autovalidateMode,
                loginButtonState: LoginButtonState.loading,
              ),
          },
        );
      },
    );
    on<LoginFormRejectedEvent>(
      (event, emit) {
        emit(
          switch (state) {
            LoginInitialState() => const LoginInitialState(
                autovalidateMode: AutovalidateMode.always,
                loginButtonState: LoginButtonState.enabled,
              ),
          },
        );
      },
    );

    on<ResetLoginButtonEvent>(
      (event, emit) {
        emit(
          switch (state) {
            LoginInitialState(autovalidateMode: final autovalidateMode) =>
              LoginInitialState(
                autovalidateMode: autovalidateMode,
                loginButtonState: LoginButtonState.enabled,
              ),
          },
        );
      },
    );
  }

  @override
  Future<void> close() async {
    emailController.dispose();
    passwordController.dispose();
    switch (state) {
      case LoginInitialState():
    }
    await super.close();
  }
}

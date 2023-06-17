import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

extension GetLoginBloc on BuildContext {
  LoginBloc get loginBloc => BlocProvider.of(this);
}

class LoginBloc extends Bloc<LoginRejectedEvent, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginBloc()
      : super(
          const LoginState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<LoginRejectedEvent>(
      (event, emit) {
        emit(
          switch (state) {
            LoginState() => const LoginState(
                autovalidateMode: AutovalidateMode.always,
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
    await super.close();
  }
}

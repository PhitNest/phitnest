import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginBloc()
      : super(
          const LoginInitialState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<SubmitLoginFormEvent>((event, emit) => switch (state) {
          LoginInitialState() => emit(
              formKey.currentState!.validate()
                  ? const LoginInitialState(
                      autovalidateMode: AutovalidateMode.disabled,
                    )
                  : const LoginInitialState(
                      autovalidateMode: AutovalidateMode.always,
                    ),
            ),
        });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

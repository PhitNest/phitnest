import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

extension GetChangePasswordBloc on BuildContext {
  ChangePasswordBloc get changePasswordBloc => BlocProvider.of(this);
}

class ChangePasswordBloc
    extends Bloc<PasswordFormRejectedEvent, ChangePasswordState> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ChangePasswordBloc()
      : super(
          const ChangePasswordState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<PasswordFormRejectedEvent>(
      (event, emit) {
        emit(
          switch (state) {
            ChangePasswordState() => const ChangePasswordState(
                autovalidateMode: AutovalidateMode.always,
              ),
          },
        );
      },
    );
  }

  @override
  Future<void> close() async {
    passwordController.dispose();
    confirmPasswordController.dispose();
    await super.close();
  }
}

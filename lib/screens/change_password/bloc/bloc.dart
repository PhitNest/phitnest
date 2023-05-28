import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

extension ChangePasswordBlocGetter on BuildContext {
  ChangePasswordBloc get changePasswordBloc => BlocProvider.of(this);
}

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ChangePasswordBloc()
      : super(
          const ChangePasswordInitialState(
            autovalidateMode: AutovalidateMode.disabled,
            changePasswordButtonState: ChangePasswordButtonState.enabled,
          ),
        ) {
    on<PasswordFormAcceptedEvent>(
      (event, emit) {
        emit(
          switch (state) {
            ChangePasswordInitialState(
              autovalidateMode: final autovalidateMode
            ) =>
              ChangePasswordInitialState(
                autovalidateMode: autovalidateMode,
                changePasswordButtonState: ChangePasswordButtonState.loading,
              ),
          },
        );
      },
    );
    on<PasswordFormRejectedEvent>(
      (event, emit) {
        emit(
          switch (state) {
            ChangePasswordInitialState() => const ChangePasswordInitialState(
                autovalidateMode: AutovalidateMode.always,
                changePasswordButtonState: ChangePasswordButtonState.enabled,
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
    switch (state) {
      case ChangePasswordInitialState():
    }
    await super.close();
  }
}

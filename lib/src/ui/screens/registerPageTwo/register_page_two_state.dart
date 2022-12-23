import 'package:flutter/material.dart';

import '../screen_state.dart';

abstract class RegisterPageTwoState extends ScreenState {
  final AutovalidateMode autovalidateMode;

  const RegisterPageTwoState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}

class InitialState extends RegisterPageTwoState {
  const InitialState({required super.autovalidateMode}) : super();
}

class ErrorState extends RegisterPageTwoState {
  final String errorMessage;

  const ErrorState({
    required this.errorMessage,
    required super.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [...super.props, errorMessage];
}

class RegisterPageTwoCubit extends ScreenCubit<RegisterPageTwoState> {
  RegisterPageTwoCubit()
      : super(const InitialState(autovalidateMode: AutovalidateMode.disabled));

  void enableAutovalidateMode() {
    if (state is InitialState) {
      setState(InitialState(autovalidateMode: AutovalidateMode.always));
    } else if (state is ErrorState) {
      setState(
        ErrorState(
          autovalidateMode: AutovalidateMode.always,
          errorMessage: (state as ErrorState).errorMessage,
        ),
      );
    } else {
      throw Exception('Cannot apply autovalidation to state: $state');
    }
  }

  void transitionToError(String message) => setState(ErrorState(
      autovalidateMode: state.autovalidateMode, errorMessage: message));

  void transitionToInitial() => setState(
        InitialState(autovalidateMode: state.autovalidateMode),
      );
}

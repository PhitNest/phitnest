import 'package:flutter/material.dart';

import '../screen_state.dart';

abstract class ForgotPasswordState extends ScreenState {
  final AutovalidateMode autovalidateMode;

  const ForgotPasswordState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}

class InitialState extends ForgotPasswordState {
  const InitialState({
    required super.autovalidateMode,
  }) : super();
}

class ErrorState extends ForgotPasswordState {
  final String errorMessage;

  const ErrorState({
    required this.errorMessage,
    required super.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [...super.props, errorMessage];
}

class LoadingState extends ForgotPasswordState {
  const LoadingState({
    required super.autovalidateMode,
  }) : super();
}

class ForgotPasswordCubit extends ScreenCubit<ForgotPasswordState> {
  ForgotPasswordCubit()
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

  void transitionToInitial() =>
      setState(InitialState(autovalidateMode: state.autovalidateMode));

  void transitionToLoading() =>
      setState(LoadingState(autovalidateMode: state.autovalidateMode));
}

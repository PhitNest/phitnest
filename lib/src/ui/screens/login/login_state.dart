import 'package:flutter/material.dart';

import '../screen_state.dart';

abstract class LoginState extends ScreenState {
  const LoginState() : super();
}

class InitialState extends LoginState {
  const InitialState() : super();
}

class LoadedState extends LoginState {
  final AutovalidateMode autovalidateMode;

  const LoadedState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}

class LoadingState extends LoginState {
  final AutovalidateMode autovalidateMode;

  const LoadingState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}

class ErrorState extends LoginState {
  final String message;
  final AutovalidateMode autovalidateMode;

  const ErrorState({
    required this.autovalidateMode,
    required this.message,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode, message];
}

class LoginCubit extends ScreenCubit<LoginState> {
  LoginCubit() : super(const InitialState());

  void transitionToLoaded() =>
      setState(const LoadedState(autovalidateMode: AutovalidateMode.disabled));

  void enableAutovalidateMode() {
    if (state is LoadedState) {
      setState(const LoadedState(autovalidateMode: AutovalidateMode.always));
    } else if (state is ErrorState) {
      setState(
        ErrorState(
          autovalidateMode: AutovalidateMode.always,
          message: (state as ErrorState).message,
        ),
      );
    } else {
      throw Exception('Cannot apply autovalidation to state: $state');
    }
  }

  void transitionToLoading() {
    if (state is LoadedState) {
      setState(LoadingState(
          autovalidateMode: (state as LoadedState).autovalidateMode));
    } else if (state is ErrorState) {
      setState(LoadingState(
          autovalidateMode: (state as ErrorState).autovalidateMode));
    } else {
      throw Exception('Cannot transition to loading from state: $state');
    }
  }

  void transitionToError(String message) => setState(ErrorState(
      autovalidateMode: (state as LoadingState).autovalidateMode,
      message: message));
}

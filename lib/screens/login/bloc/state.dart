part of 'bloc.dart';

enum LoginButtonState {
  enabled,
  loading,
}

sealed class LoginState extends Equatable {
  final AutovalidateMode autovalidateMode;
  final LoginButtonState loginButtonState;

  const LoginState({
    required this.autovalidateMode,
    required this.loginButtonState,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode, loginButtonState];
}

class LoginInitialState extends LoginState {
  const LoginInitialState({
    required super.autovalidateMode,
    required super.loginButtonState,
  }) : super();
}

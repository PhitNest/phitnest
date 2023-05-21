part of 'bloc.dart';

sealed class LoginState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const LoginState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}

class LoginInitialState extends LoginState {
  const LoginInitialState({
    required super.autovalidateMode,
  }) : super();
}

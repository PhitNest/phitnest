part of 'bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent() : super();

  @override
  List<Object?> get props => [];
}

class LoginFormAcceptedEvent extends LoginEvent {
  const LoginFormAcceptedEvent() : super();
}

class LoginFormRejectedEvent extends LoginEvent {
  const LoginFormRejectedEvent() : super();
}

class ResetLoginButtonEvent extends LoginEvent {
  const ResetLoginButtonEvent() : super();
}

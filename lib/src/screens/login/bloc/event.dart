part of 'bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent() : super();
}

class LoginFormRejectedEvent extends LoginEvent {
  const LoginFormRejectedEvent() : super();

  @override
  List<Object?> get props => [];
}

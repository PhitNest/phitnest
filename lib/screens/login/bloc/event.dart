part of 'bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent() : super();

  @override
  List<Object?> get props => [];
}

class SubmitLoginFormEvent extends LoginEvent {
  const SubmitLoginFormEvent() : super();
}

part of 'bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent() : super();

  @override
  List<Object?> get props => [];
}

class PasswordFormAcceptedEvent extends ChangePasswordEvent {
  const PasswordFormAcceptedEvent() : super();
}

class PasswordFormRejectedEvent extends ChangePasswordEvent {
  const PasswordFormRejectedEvent() : super();
}

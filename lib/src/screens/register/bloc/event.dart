part of 'bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent() : super();
}

class RegisterFormRejectedEvent extends RegisterEvent {
  const RegisterFormRejectedEvent() : super();

  @override
  List<Object?> get props => [];
}

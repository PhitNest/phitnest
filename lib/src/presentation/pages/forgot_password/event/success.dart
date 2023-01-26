import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordSuccessEvent extends ForgotPasswordEvent {
  final String email;
  final String password;

  const ForgotPasswordSuccessEvent({
    required this.email,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [];
}

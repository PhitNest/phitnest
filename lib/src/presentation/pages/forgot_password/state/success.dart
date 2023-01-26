import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final String email;
  final String password;

  const ForgotPasswordSuccessState({
    required this.email,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [];
}

import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final String email;

  const ForgotPasswordSuccessState({
    required this.email,
  }) : super();

  @override
  List<Object?> get props => [];
}

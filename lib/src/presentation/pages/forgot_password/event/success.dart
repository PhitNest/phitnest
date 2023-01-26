import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordSuccessEvent extends ForgotPasswordEvent {
  final String email;

  const ForgotPasswordSuccessEvent({required this.email}) : super();

  @override
  List<Object?> get props => [];
}

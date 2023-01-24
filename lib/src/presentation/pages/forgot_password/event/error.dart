import '../../../../common/failure.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordErrorEvent extends ForgotPasswordEvent {
  final Failure failure;
  final String email;
  final String password;

  ForgotPasswordErrorEvent({
    required this.failure,
    required this.password,
    required this.email,
  }) : super();

  @override
  List<Object?> get props => [];
}

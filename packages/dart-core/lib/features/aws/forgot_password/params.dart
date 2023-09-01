part of 'forgot_password.dart';

final class SubmitForgotPasswordParams extends Equatable {
  final String email;
  final String code;
  final String newPassword;

  const SubmitForgotPasswordParams({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, code, newPassword];
}

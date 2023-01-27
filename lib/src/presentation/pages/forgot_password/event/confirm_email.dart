import 'forgot_password_event.dart';

class ConfirmEmailEvent extends ForgotPasswordEvent {
  final String email;

  ConfirmEmailEvent({
    required this.email,
  }) : super();

  @override
  List<Object?> get props => [email];
}

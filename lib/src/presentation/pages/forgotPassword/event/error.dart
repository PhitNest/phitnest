import '../../../../common/failure.dart';
import 'forgot_password_event.dart';

class ErrorEvent extends ForgotPasswordEvent {
  final Failure failure;

  const ErrorEvent(this.failure) : super();

  @override
  List<Object?> get props => [failure];
}

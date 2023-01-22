import '../../../../common/failure.dart';
import 'login_event.dart';

/// This event is emitted when the login request fails
class LoginErrorEvent extends LoginEvent {
  final Failure failure;
  final String email;
  final String password;

  const LoginErrorEvent(this.failure, this.email, this.password) : super();

  @override
  List<Object> get props => [failure, email, password];
}

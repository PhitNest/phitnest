import '../../../../data/data_sources/backend/backend.dart';
import 'login_event.dart';

/// This event is emitted when the login request is successful
class LoginSuccessEvent extends LoginEvent {
  final LoginResponse response;

  const LoginSuccessEvent(this.response) : super();

  @override
  List<Object?> get props => [response];
}

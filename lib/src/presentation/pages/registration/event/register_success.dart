import '../../../../data/data_sources/backend/backend.dart';
import 'registration_event.dart';

class RegisterSuccessEvent extends RegistrationEvent {
  final RegisterResponse response;
  final String password;

  const RegisterSuccessEvent(this.response, this.password);

  @override
  List<Object?> get props => [response, password];
}

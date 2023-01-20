import '../../../../data/data_sources/backend/backend.dart';
import 'registration_event.dart';

class RegisterSuccessEvent extends RegistrationEvent {
  final RegisterResponse response;

  const RegisterSuccessEvent(this.response);

  @override
  List<Object?> get props => [response];
}

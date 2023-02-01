import '../../../../data/backend/backend.dart';
import 'registration_event.dart';

/// This is the event that is emitted when the user successfully registers.
class RegisterSuccessEvent extends RegistrationEvent {
  final RegisterResponse response;

  const RegisterSuccessEvent(this.response);

  @override
  List<Object?> get props => [response];
}

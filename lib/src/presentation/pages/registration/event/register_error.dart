import '../../../../common/failure.dart';
import 'registration_event.dart';

class RegisterErrorEvent extends RegistrationEvent {
  final Failure failure;

  RegisterErrorEvent(this.failure);

  @override
  List<Object?> get props => [failure];
}

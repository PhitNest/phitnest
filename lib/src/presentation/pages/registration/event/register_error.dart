import '../../../../common/failure.dart';
import 'registration_event.dart';

/// This is the event that is emitted when the users registration request fails.
/// This may be due to a UsernameExistsException in which case we should handle that.
class RegisterErrorEvent extends RegistrationEvent {
  final Failure failure;

  RegisterErrorEvent(this.failure);

  @override
  List<Object?> get props => [failure];
}

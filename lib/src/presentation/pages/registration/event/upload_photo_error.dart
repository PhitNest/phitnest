import '../../../../common/failure.dart';
import 'registration_event.dart';

/// This event is emitted when the user tries to upload a photo and an error occurs.
class UploadErrorEvent extends RegistrationEvent {
  final Failure failure;

  const UploadErrorEvent(this.failure);

  @override
  List<Object?> get props => [failure];
}

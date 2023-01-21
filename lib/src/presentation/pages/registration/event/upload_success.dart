import 'registration_event.dart';

/// This event is emitted when the user successfully uploads a photo.
class UploadSuccessEvent extends RegistrationEvent {
  const UploadSuccessEvent();

  @override
  List<Object?> get props => [];
}

import 'registration_event.dart';

/// This event is emitted when the user captures a photo.
class CapturePhotoEvent extends RegistrationEvent {
  const CapturePhotoEvent() : super();

  @override
  List<Object> get props => [];
}

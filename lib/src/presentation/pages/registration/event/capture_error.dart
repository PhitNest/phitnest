import 'package:camera/camera.dart';

import 'registration_event.dart';

/// This event is emitted when an error occurs when the camera capture.
class CaptureErrorEvent extends RegistrationEvent {
  final CameraException error;

  const CaptureErrorEvent(this.error) : super();

  @override
  List<Object?> get props => [error];
}

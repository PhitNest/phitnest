import 'package:camera/camera.dart';

import 'registration_event.dart';

class CaptureErrorEvent extends RegistrationEvent {
  final CameraException error;

  const CaptureErrorEvent(this.error) : super();

  @override
  List<Object?> get props => [error];
}

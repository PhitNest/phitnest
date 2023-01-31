import 'package:camera/camera.dart';

import 'profile_picture_event.dart';

class InitializedEvent extends ProfilePictureEvent {
  final CameraDescription cameraDescription;

  InitializedEvent(this.cameraDescription);

  @override
  List<Object?> get props => [cameraDescription];
}

import 'package:camera/camera.dart';

import 'profile_picture_event.dart';

class CaptureSuccessEvent extends ProfilePictureEvent {
  final XFile file;

  const CaptureSuccessEvent(this.file);

  @override
  List<Object?> get props => [file];
}

import 'package:async/async.dart';
import 'package:camera/camera.dart';

import 'profile_picture_state.dart';

class InitialState extends ProfilePictureState {
  final CancelableOperation<CameraDescription> getFrontCamera;

  const InitialState({
    required this.getFrontCamera,
  }) : super();

  @override
  List<Object?> get props =>
      [getFrontCamera.isCanceled, getFrontCamera.isCompleted];
}

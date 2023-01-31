import 'package:camera/camera.dart';

import '../profile_picture_state.dart';

export 'camera_error.dart';
export 'camera_loading.dart';
export 'cameraLoaded/camera_loaded.dart';

abstract class InitializedState extends ProfilePictureState {
  final CameraController cameraController;

  const InitializedState({
    required this.cameraController,
  }) : super();

  @override
  List<Object?> get props => [cameraController];
}

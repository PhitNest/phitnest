import 'package:camera/camera.dart';

import '../camera_loaded.dart';

export 'uploading.dart';
export 'upload_error.dart';
export 'upload_success.dart';

class CaptureSuccessState extends CameraLoadedState {
  final XFile file;

  const CaptureSuccessState({
    required super.cameraController,
    required this.file,
  }) : super();

  @override
  List<Object?> get props => [super.props, file];
}

import '../initialized.dart';

export 'capture_error.dart';
export 'capture_loading.dart';
export 'captureSuccess/capture_success.dart';

class CameraLoadedState extends InitializedState {
  const CameraLoadedState({
    required super.cameraController,
  }) : super();

  @override
  List<Object?> get props => [super.props];
}

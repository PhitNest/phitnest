import '../../../../../../common/failure.dart';
import 'camera_loaded.dart';

class CaptureErrorState extends CameraLoadedState {
  final Failure failure;

  const CaptureErrorState({
    required super.cameraController,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

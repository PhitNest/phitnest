import 'package:async/async.dart';

import '../../../../../common/failure.dart';
import 'initialized.dart';

class CameraLoadingState extends InitializedState {
  final CancelableOperation<Failure?> initializeCamera;

  const CameraLoadingState({
    required super.cameraController,
    required this.initializeCamera,
  }) : super();

  @override
  List<Object?> get props =>
      [super.props, initializeCamera.isCanceled, initializeCamera.isCompleted];
}

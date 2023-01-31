import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../common/failure.dart';
import 'camera_loaded.dart';

class CaptureLoadingState extends CameraLoadedState {
  final CancelableOperation<Either<XFile, Failure>> captureImage;

  const CaptureLoadingState({
    required super.cameraController,
    required this.captureImage,
  }) : super();

  @override
  List<Object?> get props =>
      [super.props, captureImage.isCanceled, captureImage.isCompleted];
}

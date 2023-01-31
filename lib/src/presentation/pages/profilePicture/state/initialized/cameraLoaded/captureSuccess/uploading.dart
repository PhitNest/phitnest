import 'package:async/async.dart';

import '../../../../../../../common/failure.dart';
import 'capture_success.dart';

class UploadingState extends CaptureSuccessState {
  final CancelableOperation<Failure?> uploadImage;

  const UploadingState({
    required super.cameraController,
    required super.file,
    required this.uploadImage,
  }) : super();

  @override
  List<Object?> get props =>
      [super.props, uploadImage.isCanceled, uploadImage.isCompleted];
}

part of profile_picture_page;

class _CaptureLoadingState extends _IInitializedState {
  final CancelableOperation<Either<XFile, Failure>> captureImage;

  const _CaptureLoadingState({
    required super.cameraController,
    required this.captureImage,
  }) : super();
}
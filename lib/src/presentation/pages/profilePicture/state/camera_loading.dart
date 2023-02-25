part of profile_picture_page;

class _CameraLoadingState extends _IProfilePictureState {
  final CameraController cameraController;
  final CancelableOperation<Failure?> initializeCamera;

  const _CameraLoadingState({
    required this.cameraController,
    required this.initializeCamera,
  }) : super();
}

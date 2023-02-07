part of profile_picture_page;

class _CameraLoadingState extends _ProfilePictureState {
  final CameraController cameraController;
  final CancelableOperation<Failure?> initializeCamera;

  const _CameraLoadingState({
    required this.cameraController,
    required this.initializeCamera,
  }) : super();

  @override
  List<Object> get props => [
        cameraController,
        initializeCamera.isCanceled,
        initializeCamera.isCompleted
      ];
}

part of profile_picture_page;

class _CameraLoadingState extends _Initialized {
  final CancelableOperation<Failure?> initializeCamera;

  const _CameraLoadingState({
    required super.cameraController,
    required this.initializeCamera,
  }) : super();

  @override
  List<Object> get props =>
      [super.props, initializeCamera.isCanceled, initializeCamera.isCompleted];
}

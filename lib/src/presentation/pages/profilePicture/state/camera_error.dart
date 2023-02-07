part of profile_picture_page;

class _CameraErrorState extends _ProfilePictureState {
  final Failure failure;
  final CameraController cameraController;

  const _CameraErrorState({
    required this.cameraController,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [cameraController, failure];
}

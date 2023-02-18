part of profile_picture_page;

class _CameraErrorState extends _IProfilePictureState {
  final Failure failure;
  final CameraController cameraController;
  final Completer<void> dismiss;

  const _CameraErrorState({
    required this.cameraController,
    required this.failure,
    required this.dismiss,
  }) : super();

  @override
  List<Object> get props => [cameraController, failure, dismiss];
}

part of profile_picture_page;

class _CameraErrorState extends _IProfilePictureState {
  final CameraController cameraController;
  final StyledErrorBanner errorBanner;

  const _CameraErrorState({
    required this.cameraController,
    required this.errorBanner,
  }) : super();

  @override
  List<Object> get props => [cameraController, errorBanner];
}

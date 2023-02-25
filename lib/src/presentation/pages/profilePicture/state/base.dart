part of profile_picture_page;

abstract class _IProfilePictureState {
  const _IProfilePictureState() : super();
}

abstract class _IInitializedState extends _IProfilePictureState {
  final CameraController cameraController;

  const _IInitializedState({
    required this.cameraController,
  }) : super();
}

abstract class _ICapturedState extends _IInitializedState {
  final XFile file;

  const _ICapturedState({
    required super.cameraController,
    required this.file,
  }) : super();
}

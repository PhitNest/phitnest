part of profile_picture_page;

abstract class _ProfilePictureState extends Equatable {
  const _ProfilePictureState() : super();
}

abstract class _Initialized extends _ProfilePictureState {
  final CameraController cameraController;

  const _Initialized({
    required this.cameraController,
  }) : super();

  @override
  List<Object> get props => [cameraController];
}

abstract class _Captured extends _Initialized {
  final XFile file;

  const _Captured({
    required super.cameraController,
    required this.file,
  }) : super();

  @override
  List<Object> get props => [file];
}

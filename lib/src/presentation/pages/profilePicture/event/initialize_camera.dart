part of profile_picture_page;

class _InitializeCameraEvent extends _ProfilePictureEvent {
  final CameraDescription cameraDescription;

  const _InitializeCameraEvent(this.cameraDescription) : super();

  @override
  List<Object?> get props => [cameraDescription];
}

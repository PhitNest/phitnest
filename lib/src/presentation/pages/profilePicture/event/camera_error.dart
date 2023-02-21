part of profile_picture_page;

class _CameraErrorEvent extends _IProfilePictureEvent {
  final Failure failure;

  const _CameraErrorEvent(this.failure) : super();
}

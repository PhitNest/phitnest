part of profile_picture_page;

class _UploadErrorEvent extends _IProfilePictureEvent {
  final Failure failure;

  const _UploadErrorEvent(this.failure) : super();
}

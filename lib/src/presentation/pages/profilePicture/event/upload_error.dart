part of profile_picture_page;

class _UploadErrorEvent extends _ProfilePictureEvent {
  final Failure failure;

  const _UploadErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}

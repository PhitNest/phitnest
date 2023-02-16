part of profile_picture_page;

class _CaptureSuccessEvent extends _IProfilePictureEvent {
  final XFile file;

  const _CaptureSuccessEvent(this.file) : super();

  @override
  List<Object> get props => [file];
}

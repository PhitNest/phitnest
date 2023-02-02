part of profile_picture_page;

class _CaptureErrorEvent extends _ProfilePictureEvent {
  final Failure failure;

  const _CaptureErrorEvent(this.failure) : super();

  @override
  List<Object?> get props => [failure];
}

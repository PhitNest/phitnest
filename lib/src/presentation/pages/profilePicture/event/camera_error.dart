part of profile_picture_page;

class _CameraErrorEvent extends _ProfilePictureEvent {
  final Failure failure;

  const _CameraErrorEvent(this.failure) : super();

  @override
  List<Object?> get props => [failure];
}

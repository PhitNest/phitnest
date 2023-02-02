part of profile_picture_page;

class _InitialState extends _ProfilePictureState {
  final CancelableOperation<CameraDescription> getFrontCamera;

  const _InitialState({
    required this.getFrontCamera,
  }) : super();

  @override
  List<Object?> get props =>
      [getFrontCamera.isCanceled, getFrontCamera.isCompleted];
}

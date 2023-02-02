part of profile_picture_page;

class _UploadingState extends _Captured {
  final CancelableOperation<Failure?> uploadImage;

  const _UploadingState({
    required super.cameraController,
    required super.file,
    required this.uploadImage,
  }) : super();

  @override
  List<Object> get props =>
      [super.props, uploadImage.isCanceled, uploadImage.isCompleted];
}

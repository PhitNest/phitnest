part of profile_picture_page;

class _UploadingState extends _ICapturedState {
  final CancelableOperation<Failure?> uploadImage;

  const _UploadingState({
    required super.cameraController,
    required super.file,
    required this.uploadImage,
  }) : super();
}

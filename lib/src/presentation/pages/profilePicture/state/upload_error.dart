part of profile_picture_page;

class _UploadErrorState extends _ICapturedState {
  final Failure failure;
  final Completer<void> dismiss;

  const _UploadErrorState({
    required super.cameraController,
    required super.file,
    required this.failure,
    required this.dismiss,
  }) : super();

  @override
  List<Object> get props => [super.props, failure, dismiss];
}

part of profile_picture_page;

class _UploadErrorState extends _Captured {
  final Failure failure;

  const _UploadErrorState({
    required super.cameraController,
    required super.file,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

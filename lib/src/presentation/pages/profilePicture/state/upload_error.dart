part of profile_picture_page;

class _UploadErrorState extends _ICapturedState {
  final StyledErrorBanner errorBanner;

  const _UploadErrorState({
    required super.cameraController,
    required super.file,
    required this.errorBanner,
  }) : super();

  @override
  List<Object> get props => [super.props, errorBanner];
}

part of profile_picture_page;

class _CaptureErrorState extends _IInitializedState {
  final StyledErrorBanner errorBanner;

  const _CaptureErrorState({
    required super.cameraController,
    required this.errorBanner,
  }) : super();

  @override
  List<Object> get props => [super.props, errorBanner];
}

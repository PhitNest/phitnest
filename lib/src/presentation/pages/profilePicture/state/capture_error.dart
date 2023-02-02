part of profile_picture_page;

class _CaptureErrorState extends _Initialized {
  final Failure failure;

  const _CaptureErrorState({
    required super.cameraController,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

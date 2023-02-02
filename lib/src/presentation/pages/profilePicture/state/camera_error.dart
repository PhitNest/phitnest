part of profile_picture_page;

class _CameraErrorState extends _Initialized {
  final Failure failure;

  const _CameraErrorState({
    required super.cameraController,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

part of profile_picture_page;

class _CaptureErrorState extends _IInitializedState {
  final Failure failure;
  final Completer<void> dismiss;

  const _CaptureErrorState({
    required super.cameraController,
    required this.failure,
    required this.dismiss,
  }) : super();

  @override
  List<Object> get props => [super.props, failure, dismiss];
}

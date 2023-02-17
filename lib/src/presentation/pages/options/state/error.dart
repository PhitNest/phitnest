part of options_page;

class _LoadingErrorState extends _IOptionsState {
  final Failure failure;
  final Completer<void> dismiss;

  const _LoadingErrorState({
    required super.response,
    required this.failure,
    required this.dismiss,
  }) : super();

  @override
  List<Object> get props => [super.props, failure, dismiss];
}

part of options_page;

class _SignOutErrorState extends _ILoadedState {
  final Failure failure;
  final Completer<void> dismiss;

  const _SignOutErrorState({
    required super.response,
    required this.failure,
    required this.dismiss,
  }) : super();

  @override
  List<Object> get props => [super.props, failure, dismiss];
}

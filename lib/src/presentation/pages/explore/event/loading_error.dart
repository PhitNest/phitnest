part of explore_page;

class _LoadingErrorEvent extends _ExploreEvent {
  final Failure failure;

  const _LoadingErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}

part of explore_page;

class _LoadingErrorEvent extends _IExploreEvent {
  final Failure failure;

  const _LoadingErrorEvent(this.failure) : super();
}

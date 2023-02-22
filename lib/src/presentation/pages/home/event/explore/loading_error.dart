part of home_page;

class _ExploreLoadingErrorEvent extends _IExploreEvent {
  final Failure failure;

  const _ExploreLoadingErrorEvent(this.failure) : super();
}

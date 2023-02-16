part of explore_page;

class _LoadedEvent extends _IExploreEvent {
  final UserExploreResponse response;

  const _LoadedEvent(this.response) : super();

  @override
  List<Object> get props => [response];
}

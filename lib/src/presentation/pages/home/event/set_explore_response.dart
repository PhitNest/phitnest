part of home_page;

class _SetExploreResponseEvent extends _IHomeEvent {
  final UserExploreResponse response;

  const _SetExploreResponseEvent(this.response) : super();

  @override
  List<Object> get props => [response];
}

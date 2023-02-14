part of explore_page;

class _LoadWithInitialEvent extends _ExploreEvent {
  final UserExploreResponse initialData;

  const _LoadWithInitialEvent(this.initialData) : super();

  @override
  List<Object> get props => [initialData];
}

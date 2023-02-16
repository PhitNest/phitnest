part of home_page;

class _RefreshSessionEvent extends _IHomeEvent {
  final RefreshSessionResponse response;

  const _RefreshSessionEvent(this.response) : super();

  @override
  List<Object> get props => [response];
}

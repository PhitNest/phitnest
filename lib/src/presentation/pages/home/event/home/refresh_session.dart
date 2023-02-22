part of home_page;

class _HomeRefreshSessionEvent extends _IHomeEvent {
  final RefreshSessionResponse response;

  const _HomeRefreshSessionEvent(this.response) : super();
}

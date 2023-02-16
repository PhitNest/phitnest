part of home_page;

class _LoadedUserEvent extends _IHomeEvent {
  final GetUserResponse response;

  const _LoadedUserEvent(this.response) : super();

  @override
  List<Object> get props => [response];
}

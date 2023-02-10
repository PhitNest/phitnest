part of home_page;

class _LoginEvent extends _HomeEvent {
  final LoginResponse response;

  const _LoginEvent(this.response) : super();

  @override
  List<Object> get props => [response];
}

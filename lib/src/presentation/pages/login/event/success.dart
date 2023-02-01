part of login_page;

class _SuccessEvent extends _LoginEvent {
  final LoginResponse response;

  const _SuccessEvent(this.response) : super();

  @override
  List<Object?> get props => [response];
}

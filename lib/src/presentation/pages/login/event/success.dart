part of login_page;

class _SuccessEvent extends _ILoginEvent {
  final LoginResponse response;

  const _SuccessEvent(this.response) : super();
}

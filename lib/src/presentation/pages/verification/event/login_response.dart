part of verification_page;

class _LoginResponseEvent extends _IVerificationEvent {
  final LoginResponse? response;

  const _LoginResponseEvent(this.response) : super();
}

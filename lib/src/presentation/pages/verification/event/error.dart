part of verification_page;

class _ErrorEvent extends _IVerificationEvent {
  final Failure failure;

  const _ErrorEvent(this.failure) : super();
}

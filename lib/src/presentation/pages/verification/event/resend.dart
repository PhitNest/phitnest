part of verification_page;

class _ResendEvent extends _IVerificationEvent {
  final Future<Failure?> Function() resend;

  const _ResendEvent(this.resend) : super();

  @override
  List<Object> get props => [resend];
}

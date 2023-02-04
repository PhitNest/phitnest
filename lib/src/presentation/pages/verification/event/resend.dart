part of verification_page;

class _ResendEvent extends _VerificationEvent {
  final Future<Failure?> Function() resend;

  const _ResendEvent(this.resend) : super();

  @override
  List<Object> get props => [resend];
}

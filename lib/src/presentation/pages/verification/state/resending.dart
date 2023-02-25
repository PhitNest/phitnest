part of verification_page;

class _ResendingState extends _IVerificationState {
  final CancelableOperation<Failure?> resend;

  const _ResendingState({
    required this.resend,
  }) : super();
}

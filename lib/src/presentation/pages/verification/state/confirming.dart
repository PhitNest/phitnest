part of verification_page;

class _ConfirmingState extends _IVerificationState {
  final CancelableOperation<Failure?> confirm;

  const _ConfirmingState({
    required this.confirm,
  }) : super();
}
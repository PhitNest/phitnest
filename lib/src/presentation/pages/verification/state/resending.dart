part of verification_page;

class _ResendingState extends _IVerificationState {
  final CancelableOperation<Failure?> operation;

  const _ResendingState({
    required this.operation,
  }) : super();

  @override
  List<Object> get props => [super.props, operation.value];
}

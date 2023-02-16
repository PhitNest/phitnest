part of verification_page;

class _ConfirmingState extends _IVerificationState {
  final CancelableOperation<Either<LoginResponse?, Failure>> operation;

  const _ConfirmingState({
    required this.operation,
  }) : super();

  @override
  List<Object> get props => [super.props, operation.value];
}

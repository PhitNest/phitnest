part of verification_page;

class _ResendErrorState extends _VerificationState {
  final Failure failure;

  const _ResendErrorState({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

part of verification_page;

class _ConfirmErrorState extends _IVerificationState {
  final Failure failure;

  const _ConfirmErrorState({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

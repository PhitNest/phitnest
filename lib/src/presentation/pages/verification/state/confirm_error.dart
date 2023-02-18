part of verification_page;

class _ErrorState extends _IVerificationState {
  final Failure failure;
  final Completer<void> dismiss;

  const _ErrorState({
    required this.failure,
    required this.dismiss,
  }) : super();

  @override
  List<Object> get props => [super.props, failure, dismiss];
}

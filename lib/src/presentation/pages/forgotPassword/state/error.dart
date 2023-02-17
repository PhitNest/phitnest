part of forgot_password_page;

class _ErrorState extends _IForgotPasswordState {
  final Failure failure;
  final Completer<void> dismiss;

  const _ErrorState({
    required super.autovalidateMode,
    required this.failure,
    required this.dismiss,
  }) : super();

  @override
  List<Object> get props => [super.props, failure, dismiss];
}

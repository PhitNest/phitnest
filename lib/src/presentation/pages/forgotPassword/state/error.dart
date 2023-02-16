part of forgot_password_page;

class _ErrorState extends _IForgotPasswordState {
  final Failure failure;

  const _ErrorState({
    required super.autovalidateMode,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

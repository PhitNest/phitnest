part of forgot_password_page;

class _ErrorState extends _IForgotPasswordState {
  final StyledErrorBanner errorBanner;

  const _ErrorState({
    required super.autovalidateMode,
    required this.errorBanner,
  }) : super();

  @override
  List<Object> get props => [super.props, errorBanner];
}

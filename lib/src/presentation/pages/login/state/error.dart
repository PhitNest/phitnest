part of login_page;

class _ErrorState extends _ILoginState {
  final StyledErrorBanner errorBanner;

  const _ErrorState({
    required super.autovalidateMode,
    required super.invalidCredentials,
    required this.errorBanner,
  }) : super();

  @override
  List<Object> get props => [super.props, errorBanner];
}

part of verification_page;

class _ErrorState extends _IVerificationState {
  final StyledErrorBanner banner;

  const _ErrorState({
    required this.banner,
  }) : super();

  @override
  List<Object> get props => [super.props, banner];
}

part of options_page;

class _SignOutErrorState extends _ILoadedState {
  final StyledErrorBanner errorBanner;

  const _SignOutErrorState({
    required super.response,
    required this.errorBanner,
  }) : super();

  @override
  List<Object> get props => [super.props, errorBanner];
}

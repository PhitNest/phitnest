part of options_page;

class _LoadingErrorState extends _IOptionsState {
  final StyledErrorBanner errorBanner;

  const _LoadingErrorState({
    required super.response,
    required this.errorBanner,
  }) : super();

  @override
  List<Object> get props => [super.props, errorBanner];
}

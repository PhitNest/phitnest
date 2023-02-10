part of options_page;

class _LoadingErrorState extends _OptionsState {
  final Failure failure;

  const _LoadingErrorState({
    required super.response,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

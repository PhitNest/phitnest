part of options_page;

class _LoadingErrorState extends _OptionsState {
  final Failure failure;

  const _LoadingErrorState({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [failure];
}

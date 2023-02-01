part of options_page;

class _ErrorState extends _OptionsState {
  final Failure failure;

  const _ErrorState({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [failure];
}

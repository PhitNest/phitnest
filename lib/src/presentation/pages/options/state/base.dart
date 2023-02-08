part of options_page;

abstract class _OptionsState extends Equatable {
  const _OptionsState() : super();

  @override
  List<Object> get props => [];
}

abstract class _LoadedState extends _OptionsState {
  final GetUserResponse response;

  const _LoadedState({
    required this.response,
  }) : super();

  @override
  List<Object> get props => [response];
}

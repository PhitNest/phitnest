part of options_page;

abstract class _OptionsState extends Equatable {
  final GetUserResponse response;

  const _OptionsState({
    required this.response,
  }) : super();

  @override
  List<Object> get props => [response];
}

abstract class _LoadedState extends _OptionsState {
  const _LoadedState({
    required super.response,
  }) : super();
}

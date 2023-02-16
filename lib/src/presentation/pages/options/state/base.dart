part of options_page;

abstract class _IOptionsState extends Equatable {
  final GetUserResponse response;

  const _IOptionsState({
    required this.response,
  }) : super();

  @override
  List<Object> get props => [response];
}

abstract class _ILoadedState extends _IOptionsState {
  const _ILoadedState({
    required super.response,
  }) : super();
}

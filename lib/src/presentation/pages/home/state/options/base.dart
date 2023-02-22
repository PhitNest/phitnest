part of home_page;

abstract class _IOptionsState extends Equatable {
  final GetUserResponse response;

  const _IOptionsState({
    required this.response,
  }) : super();

  @override
  List<Object> get props => [response];
}

abstract class _IOptionsLoadedState extends _IOptionsState {
  const _IOptionsLoadedState({
    required super.response,
  }) : super();
}

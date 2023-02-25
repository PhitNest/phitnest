part of home_page;

abstract class _IOptionsState {
  final GetUserResponse response;

  const _IOptionsState({
    required this.response,
  }) : super();
}

abstract class _IOptionsLoadedState extends _IOptionsState {
  const _IOptionsLoadedState({
    required super.response,
  }) : super();
}

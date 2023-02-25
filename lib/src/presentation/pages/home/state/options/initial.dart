part of home_page;

class _OptionsInitialState extends _IOptionsState {
  final CancelableOperation<Either<GetUserResponse, Failure>> getUser;

  const _OptionsInitialState({
    required this.getUser,
  }) : super();
}

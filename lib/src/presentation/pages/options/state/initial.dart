part of options_page;

class _InitialState extends _OptionsState {
  final CancelableOperation<Either<GetUserResponse, Failure>> getUser;
  final GetUserResponse response;

  const _InitialState({
    required this.getUser,
    required this.response,
  }) : super();

  @override
  List<Object> get props => [getUser.value, response];
}

part of options_page;

class _InitialState extends _OptionsState {
  final CancelableOperation<Either<GetUserResponse, Failure>> getUser;

  const _InitialState({
    required this.getUser,
  }) : super();

  @override
  List<Object> get props => [getUser.value];
}

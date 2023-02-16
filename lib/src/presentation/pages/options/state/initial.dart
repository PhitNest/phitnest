part of options_page;

class _InitialState extends _IOptionsState {
  final CancelableOperation<Either<GetUserResponse, Failure>> getUser;

  const _InitialState({
    required super.response,
    required this.getUser,
  }) : super();

  @override
  List<Object> get props => [super.props, getUser.value];
}

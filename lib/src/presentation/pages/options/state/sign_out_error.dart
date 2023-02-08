part of options_page;

class _SignOutErrorState extends _LoadedState {
  final Failure failure;

  const _SignOutErrorState({
    required super.response,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

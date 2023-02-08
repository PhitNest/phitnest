part of options_page;

class _SignOutLoadingState extends _LoadedState {
  final CancelableOperation<Failure?> signOut;

  const _SignOutLoadingState({
    required super.response,
    required this.signOut,
  }) : super();

  @override
  List<Object> get props =>
      [super.props, signOut.isCanceled, signOut.isCompleted];
}

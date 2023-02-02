part of options_page;

class _SignOutLoadingState extends _OptionsState {
  final CancelableOperation<Failure?> signOut;

  const _SignOutLoadingState({
    required this.signOut,
  }) : super();

  @override
  List<Object> get props => [signOut.isCanceled, signOut.isCompleted];
}

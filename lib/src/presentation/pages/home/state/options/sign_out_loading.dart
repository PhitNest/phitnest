part of home_page;

class _OptionsSignOutLoadingState extends _IOptionsLoadedState {
  final CancelableOperation<Failure?> signOut;

  const _OptionsSignOutLoadingState({
    required this.signOut,
  }) : super();
}

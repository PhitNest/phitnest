part of home_page;

class _OptionsSignOutLoadingState extends _IOptionsLoadedState {
  final CancelableOperation<Failure?> signOut;

  const _OptionsSignOutLoadingState({
    required super.response,
    required this.signOut,
  }) : super();
}

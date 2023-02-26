part of home_page;

class _OptionsBloc extends Bloc<_IOptionsEvent, _IOptionsState> {
  final AuthMethods authMethods;

  _OptionsBloc({
    required this.authMethods,
  }) : super(
          _OptionsInitialState(
            getUser: CancelableOperation.fromFuture(
              authMethods.withAuth(
                (accessToken) =>
                    Repositories.user.getUser(accessToken: accessToken),
              ),
            ),
          ),
        ) {
    if (state is _OptionsInitialState) {
      final getUser = (state as _OptionsInitialState).getUser;
      getUser.then(
        (either) => add(
          either.fold(
            (response) => const _OptionsLoadedUserEvent(),
            (failure) => _OptionsErrorEvent(failure: failure),
          ),
        ),
      );
    }
    on<_OptionsSignOutEvent>(onSignOut);
    on<_OptionsSignOutResponseEvent>(onSignOutResponse);
    on<_OptionsErrorEvent>(onLoadingError);
    on<_OptionsLoadedUserEvent>(onLoaded);
    on<_OptionsEditProfilePictureEvent>(onEditProfilePicture);
    on<_OptionsReloadEvent>(onReload);
  }

  @override
  Future<void> close() async {
    if (state is _OptionsInitialState) {
      final state = this.state as _OptionsInitialState;
      await state.getUser.cancel();
    }
    if (state is _OptionsSignOutLoadingState) {
      final state = this.state as _OptionsSignOutLoadingState;
      await state.signOut.cancel();
    }
    return super.close();
  }
}

extension _OptionsBlocExt on BuildContext {
  _OptionsBloc get optionsBloc => read();
}

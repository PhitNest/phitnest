part of options_page;

class _OptionsBloc extends Bloc<_OptionsEvent, _OptionsState> {
  final T Function<T>(T Function(String accessToken) f) withAuth;
  final ProfilePictureUserEntity initialUser;
  final GymEntity initialGym;

  _OptionsBloc({
    required this.withAuth,
    required this.initialUser,
    required this.initialGym,
  }) : super(
          _InitialState(
            getUser: CancelableOperation.fromFuture(
              withAuth(
                (accessToken) =>
                    Repositories.user.getUser(accessToken: accessToken),
              ),
            ),
          ),
        ) {
    if (state is _InitialState) {
      final getUser = (state as _InitialState).getUser;
      getUser.then(
        (either) => either.fold(
          (response) => add(_LoadedUserEvent(response: response)),
          (failure) => add(_ErrorEvent(failure: failure)),
        ),
      );
    }
    on<_SignOutEvent>(onSignOut);
    on<_SignOutErrorEvent>(onSignOutError);
    on<_SignOutSuccessEvent>(onSignOutSuccess);
    on<_ErrorEvent>(onLoadingError);
    on<_LoadedUserEvent>(onLoaded);
  }

  @override
  Future<void> close() {
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      state.getUser.cancel();
    } else if (state is _SignOutLoadingState) {
      final state = this.state as _SignOutLoadingState;
      state.signOut.cancel();
    }
    return super.close();
  }
}

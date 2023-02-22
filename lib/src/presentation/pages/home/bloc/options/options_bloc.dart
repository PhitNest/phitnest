part of home_page;

class _OptionsBloc extends Bloc<_IOptionsEvent, _IOptionsState> {
  final Future<Either<T, Failure>> Function<T>(
      Future<Either<T, Failure>> Function(String accessToken) f) withAuth;
  final Future<Failure?> Function(
      Future<Failure?> Function(String accessToken) f) withAuthVoid;

  _OptionsBloc({
    required this.withAuth,
    required this.withAuthVoid,
  }) : super(
          _OptionsInitialState(
            response: GetUserResponse(
              id: Cache.user.user!.id,
              firstName: Cache.user.user!.firstName,
              email: Cache.user.user!.email,
              lastName: Cache.user.user!.lastName,
              cognitoId: Cache.user.user!.cognitoId,
              confirmed: Cache.user.user!.confirmed,
              profilePictureUrl: Cache.profilePicture.profilePictureUrl!,
              gymId: Cache.user.user!.gymId,
              gym: Cache.gym.gym!,
            ),
            getUser: CancelableOperation.fromFuture(
              withAuth(
                (accessToken) =>
                    Repositories.user.getUser(accessToken: accessToken),
              ),
            ),
          ),
        ) {
    if (state is _OptionsInitialState) {
      final getUser = (state as _OptionsInitialState).getUser;
      getUser.then(
        (either) => either.fold(
          (response) => add(_OptionsLoadedUserEvent(response: response)),
          (failure) => add(_OptionsErrorEvent(failure: failure)),
        ),
      );
    }
    on<_OptionsSignOutEvent>(onSignOut);
    on<_OptionsSignOutResponseEvent>(onSignOutResponse);
    on<_OptionsErrorEvent>(onLoadingError);
    on<_OptionsLoadedUserEvent>(onLoaded);
    on<_OptionsEditProfilePictureEvent>(onEditProfilePicture);
    on<_OptionsSetProfilePictureEvent>(onSetProfilePicture);
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

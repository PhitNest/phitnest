part of options_page;

class _OptionsBloc extends Bloc<_OptionsEvent, _OptionsState> {
  final Future<Either<T, Failure>> Function<T>(
      Future<Either<T, Failure>> Function(String accessToken) f) withAuth;
  final Future<Failure?> Function(
      Future<Failure?> Function(String accessToken) f) withAuthVoid;
  final ProfilePictureUserEntity initialUser;
  final GymEntity initialGym;

  _OptionsBloc({
    required this.withAuth,
    required this.withAuthVoid,
    required this.initialUser,
    required this.initialGym,
  }) : super(
          _InitialState(
            response: GetUserResponse(
              id: initialUser.id,
              firstName: initialUser.firstName,
              email: initialUser.email,
              lastName: initialUser.lastName,
              cognitoId: initialUser.cognitoId,
              confirmed: initialUser.confirmed,
              profilePictureUrl: initialUser.profilePictureUrl,
              gymId: initialUser.gymId,
              gym: initialGym,
            ),
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
    on<_EditProfilePictureEvent>(onEditProfilePicture);
    on<_SetProfilePictureEvent>(onSetProfilePicture);
  }

  @override
  Future<void> close() async {
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      await state.getUser.cancel();
    } else if (state is _SignOutLoadingState) {
      final state = this.state as _SignOutLoadingState;
      await state.signOut.cancel();
    }
    return super.close();
  }
}

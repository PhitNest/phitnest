part of options_page;

class _OptionsBloc extends Bloc<_IOptionsEvent, _IOptionsState> {
  final Future<Either<T, Failure>> Function<T>(
      Future<Either<T, Failure>> Function(String accessToken) f) withAuth;
  final Future<Failure?> Function(
      Future<Failure?> Function(String accessToken) f) withAuthVoid;

  _OptionsBloc({
    required this.withAuth,
    required this.withAuthVoid,
  }) : super(
          _InitialState(
            response: GetUserResponse(
              id: Cache.user!.id,
              firstName: Cache.user!.firstName,
              email: Cache.user!.email,
              lastName: Cache.user!.lastName,
              cognitoId: Cache.user!.cognitoId,
              confirmed: Cache.user!.confirmed,
              profilePictureUrl: Cache.profilePictureUrl!,
              gymId: Cache.user!.gymId,
              gym: Cache.gym!,
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
    on<_SignOutResponseEvent>(onSignOutResponse);
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
    }
    if (state is _SignOutLoadingState) {
      final state = this.state as _SignOutLoadingState;
      await state.signOut.cancel();
    }
    if (state is _LoadingErrorState) {
      final state = this.state as _LoadingErrorState;
      state.errorBanner.dismiss();
    }
    return super.close();
  }
}

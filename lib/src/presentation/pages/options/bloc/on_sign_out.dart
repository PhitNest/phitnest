part of options_page;

extension _OnSignOut on _OptionsBloc {
  void onSignOut(
    _SignOutEvent event,
    Emitter<_OptionsState> emit,
  ) async {
    if (state is _LoadedState) {
      final state = this.state as _LoadedState;
      emit(
        _SignOutLoadingState(
          response: state.response,
          signOut: CancelableOperation.fromFuture(
            withAuthVoid(
              (accessToken) => Repositories.auth.signOut(
                accessToken: accessToken,
                allDevices: true,
              ),
            ),
          )..then(
              (failure) => add(
                failure != null
                    ? _SignOutErrorEvent(failure)
                    : const _SignOutSuccessEvent(),
              ),
            ),
        ),
      );
    } else if (state is _InitialState) {
      final state = this.state as _InitialState;
      await state.getUser.cancel();
      emit(
        _SignOutLoadingState(
          response: GetUserResponse(
            id: initialUser.id,
            email: initialUser.email,
            cognitoId: initialUser.cognitoId,
            confirmed: initialUser.confirmed,
            firstName: initialUser.firstName,
            gymId: initialUser.gymId,
            lastName: initialUser.lastName,
            profilePictureUrl: initialUser.profilePictureUrl,
            gym: initialGym,
          ),
          signOut: CancelableOperation.fromFuture(
            withAuthVoid(
              (accessToken) => Repositories.auth.signOut(
                accessToken: accessToken,
                allDevices: true,
              ),
            ),
          )..then(
              (failure) => add(
                failure != null
                    ? _SignOutErrorEvent(failure)
                    : const _SignOutSuccessEvent(),
              ),
            ),
        ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}

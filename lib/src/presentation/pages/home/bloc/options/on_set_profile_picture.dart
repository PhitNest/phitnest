part of home_page;

extension _OptionsOnSetProfilePicture on _OptionsBloc {
  void onSetProfilePicture(
    _OptionsSetProfilePictureEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    if (state is _OptionsEditProfilePictureState) {
      final state = this.state as _OptionsEditProfilePictureState;
      emit(
        _OptionsInitialState(
          response: state.response,
          getUser: CancelableOperation.fromFuture(
            authMethods.withAuth(
              (accessToken) =>
                  Repositories.user.getUser(accessToken: accessToken),
            ),
          )..then(
              (either) => add(
                either.fold(
                  (response) => _OptionsLoadedUserEvent(response: response),
                  (failure) => _OptionsErrorEvent(failure: failure),
                ),
              ),
            ),
        ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}

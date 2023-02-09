part of options_page;

extension _OnSetProfilePicture on _OptionsBloc {
  void onSetProfilePicture(
    _SetProfilePictureEvent event,
    Emitter<_OptionsState> emit,
  ) {
    if (state is _LoadedState) {
      final state = this.state as _LoadedState;
      emit(
        _InitialState(
          response: state.response,
          getUser: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) =>
                  Repositories.user.getUser(accessToken: accessToken),
            ),
          )..then(
              (either) => add(
                either.fold(
                  (response) => _LoadedUserEvent(response: response),
                  (failure) => _ErrorEvent(failure: failure),
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

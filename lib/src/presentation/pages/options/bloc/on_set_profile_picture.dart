part of options_page;

extension _OnSetProfilePicture on _OptionsBloc {
  void onSetProfilePicture(
    _SetProfilePictureEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    CachedNetworkImage.evictFromCache(Cache.profilePictureImageCache);
    if (state is _EditProfilePictureState) {
      final state = this.state as _EditProfilePictureState;
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

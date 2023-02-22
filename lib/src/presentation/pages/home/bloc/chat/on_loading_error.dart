part of home_page;

extension _ChatOnLoadingError on _ChatBloc {
  void onLoadingError(_ChatLoadingErrorEvent event, Emitter<_IChatState> emit) {
    StyledErrorBanner.show(event.failure);
    if (state is _ChatReloadingState) {
      final state = this.state as _ChatReloadingState;
      emit(
        _ChatReloadingState(
          conversations: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.friendship.friendsAndMessages(
                accessToken,
              ),
            ),
          )..then(
              (either) => add(
                either.fold(
                  (response) => _ChatLoadedEvent(response),
                  (failure) => _ChatLoadingErrorEvent(failure),
                ),
              ),
            ),
          response: state.response,
        ),
      );
    } else {
      emit(
        _ChatLoadingState(
          conversations: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.friendship.friendsAndMessages(
                accessToken,
              ),
            ),
          )..then(
              (either) => add(
                either.fold(
                  (response) => _ChatLoadedEvent(response),
                  (failure) => _ChatLoadingErrorEvent(failure),
                ),
              ),
            ),
        ),
      );
    }
  }
}

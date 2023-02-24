part of home_page;

extension _ChatOnLoadingError on _ChatBloc {
  void onLoadingError(_ChatLoadingErrorEvent event, Emitter<_IChatState> emit) {
    StyledErrorBanner.show(event.failure);
    final conversations = CancelableOperation.fromFuture(
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
      );
    if (state is _ChatReloadingState) {
      emit(
        _ChatReloadingState(
          conversations: conversations,
        ),
      );
    } else {
      emit(
        _ChatLoadingState(
          conversations: conversations,
        ),
      );
    }
  }
}

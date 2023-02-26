part of home_page;

extension _ChatOnLoaded on _ChatBloc {
  void onLoaded(_ChatLoadedEvent event, Emitter<_IChatState> emit) =>
      emit(const _ChatLoadedState());
}

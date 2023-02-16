part of explore_page;

extension _OnLoaded on _ExploreBloc {
  void onLoaded(_LoadedEvent event, Emitter<_IExploreState> emit) => emit(
        _LoadedState(
          logoPressSubscription: state is _ReloadingState
              ? (state as _ReloadingState).logoPressSubscription
              : logoPressStream.listen(
                  (press) {
                    if (press == PressType.down) {
                      add(const _PressDownEvent());
                    } else {
                      add(const _ReleaseEvent());
                    }
                  },
                ),
          userExploreResponse: event.response,
        ),
      );
}

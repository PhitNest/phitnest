part of home_page;

extension _OnLogoPressed on _HomeBloc {
  void onLogoPressed(
    _LogoPressedEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        state.copyWithFreezeAnimation(
          event.press == PressType.down &&
              !state.darkMode &&
              (Cache.userExplore?.isNotEmpty ?? false),
        ),
      );
}

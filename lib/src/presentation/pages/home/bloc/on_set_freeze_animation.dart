part of home_page;

extension _OnSetFreezeAnimation on _HomeBloc {
  void onSetFreezeAnimation(
    _SetFreezeAnimationEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(state.copyWithFreezeAnimation(event.freeze));
}

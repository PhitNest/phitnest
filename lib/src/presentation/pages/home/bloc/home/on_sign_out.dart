part of home_page;

extension _HomeOnSignOut on _HomeBloc {
  void onSignOut(
    _HomeSignOutEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _HomeSignOutState(
          currentPage: state.currentPage,
        ),
      );
}

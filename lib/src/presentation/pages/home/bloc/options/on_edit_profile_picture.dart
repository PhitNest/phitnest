part of home_page;

extension _OptionsOnEditProfilePicture on _OptionsBloc {
  void onEditProfilePicture(
    _OptionsEditProfilePictureEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    if (state is _IOptionsLoadedState) {
      final state = this.state as _IOptionsLoadedState;
      emit(
        _OptionsEditProfilePictureState(
          response: state.response,
        ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}

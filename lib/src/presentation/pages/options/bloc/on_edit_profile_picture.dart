part of options_page;

extension _OnEditProfilePicture on _OptionsBloc {
  void onEditProfilePicture(
    _EditProfilePictureEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(
        _EditProfilePictureState(
          response: state.response,
        ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}

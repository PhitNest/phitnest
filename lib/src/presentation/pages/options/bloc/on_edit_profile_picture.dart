part of options_page;

extension _OnEditProfilePicture on _OptionsBloc {
  void onEditProfilePicture(
    _EditProfilePictureEvent event,
    Emitter<_OptionsState> emit,
  ) {
    if (state is _LoadedState) {
      final state = this.state as _LoadedState;
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

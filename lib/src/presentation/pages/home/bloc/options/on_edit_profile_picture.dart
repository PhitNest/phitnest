part of home_page;

extension _OptionsOnEditProfilePicture on _OptionsBloc {
  void onEditProfilePicture(
    _OptionsEditProfilePictureEvent event,
    Emitter<_IOptionsState> emit,
  ) =>
      emit(const _OptionsEditProfilePictureState());
}

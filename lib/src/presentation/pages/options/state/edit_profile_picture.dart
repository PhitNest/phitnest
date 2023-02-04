part of options_page;

class _EditProfilePictureState extends _OptionsState {
  final CancelableOperation onEditProfilePic;

  _EditProfilePictureState({
    required this.onEditProfilePic,
  }) : super();

  @override
  List<Object> get props => [onEditProfilePic];
}

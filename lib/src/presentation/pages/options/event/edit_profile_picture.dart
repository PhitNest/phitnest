part of options_page;

class _EditProfilePictureEvent extends _OptionsEvent {
  final XFile newProfilePicture;

  const _EditProfilePictureEvent({
    required this.newProfilePicture,
  }) : super();

  @override
  List<Object> get props => [newProfilePicture];
}

part of options_page;

class _SetProfilePictureEvent extends _OptionsEvent {
  final XFile photo;

  const _SetProfilePictureEvent(this.photo) : super();

  @override
  List<Object> get props => [photo];
}

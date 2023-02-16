part of options_page;

class _SetProfilePictureEvent extends _IOptionsEvent {
  final XFile photo;

  const _SetProfilePictureEvent(this.photo) : super();

  @override
  List<Object> get props => [photo];
}

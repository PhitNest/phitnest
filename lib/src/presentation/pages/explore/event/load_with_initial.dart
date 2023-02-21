part of explore_page;

class _LoadWithInitialEvent extends _IExploreEvent {
  final List<ProfilePicturePublicUserEntity> initialData;

  const _LoadWithInitialEvent(this.initialData) : super();
}

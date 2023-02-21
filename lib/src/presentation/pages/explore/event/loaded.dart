part of explore_page;

class _LoadedEvent extends _IExploreEvent {
  final List<ProfilePicturePublicUserEntity> response;

  const _LoadedEvent(this.response) : super();
}

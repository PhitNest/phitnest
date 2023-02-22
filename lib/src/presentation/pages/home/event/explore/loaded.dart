part of home_page;

class _ExploreLoadedEvent extends _IExploreEvent {
  final List<ProfilePicturePublicUserEntity> response;

  const _ExploreLoadedEvent(this.response) : super();
}

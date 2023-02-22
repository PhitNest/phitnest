part of cache;

class _UserCache {
  static const kGetUser = 'user';
  static const kUserExplore = 'user.explore';

  const _UserCache();

  UserEntity? get user => getCachedObject(kGetUser, UserEntity.fromJson);

  Future<void> cacheUser(UserEntity? user) => cacheObject(kGetUser, user);

  List<ProfilePicturePublicUserEntity>? get userExploreResponse =>
      getCachedList(kUserExplore, ProfilePicturePublicUserEntity.fromJson);

  Future<void> cacheUserExplore(
          List<ProfilePicturePublicUserEntity>? response) =>
      cacheList(kUserExplore, response);
}

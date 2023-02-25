part of cache;

class _UserCache {
  static const kGetUser = 'user';
  static const kUserExplore = 'user.explore';

  const _UserCache();

  UserEntity? get user => getCachedObject(kGetUser, UserEntity.fromJson);

  GetUserResponse? get userResponse {
    final theUser = user;
    final theGym = Cache.gym.gym;
    final theProfilePictureUrl = Cache.profilePicture.profilePictureUrl;
    if (theUser != null && theGym != null && theProfilePictureUrl != null) {
      return GetUserResponse(
        id: theUser.id,
        email: theUser.email,
        firstName: theUser.firstName,
        lastName: theUser.lastName,
        profilePictureUrl: theProfilePictureUrl,
        gym: theGym,
        gymId: theUser.gymId,
        cognitoId: theUser.cognitoId,
        confirmed: theUser.confirmed,
      );
    } else {
      return null;
    }
  }

  Future<void> cacheGetUserResponse(GetUserResponse? response) => Future.wait(
        [
          CachedNetworkImage.evictFromCache(
              Cache.profilePicture.profilePictureImageCacheKey),
          Cache.gym.cacheGym(response?.gym),
          Cache.user.cacheUser(response),
          Cache.profilePicture
              .cacheProfilePictureUrl(response?.profilePictureUrl),
        ],
      );

  Future<void> cacheUser(UserEntity? user) => cacheObject(kGetUser, user);

  List<ProfilePicturePublicUserEntity>? get userExploreResponse =>
      getCachedList(kUserExplore, ProfilePicturePublicUserEntity.fromJson);

  Future<void> cacheUserExplore(
          List<ProfilePicturePublicUserEntity>? response) =>
      cacheList(kUserExplore, response);
}

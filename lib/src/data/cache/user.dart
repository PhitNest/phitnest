part of cache;

UserEntity? get _user => getCachedObject(_Keys.user, UserEntity.fromJson);

Future<void> _cacheUser(UserEntity? user) => cacheObject(_Keys.user, user);

List<ProfilePicturePublicUserEntity>? get _userExploreResponse => getCachedList(
      _Keys.userExplore,
      ProfilePicturePublicUserEntity.fromJson,
    );

Future<void> _cacheUserExploreResponse(
        List<ProfilePicturePublicUserEntity>? response) =>
    cacheList(_Keys.userExplore, response);

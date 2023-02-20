part of cache;

UserEntity? get _user => getCachedObject(_Keys.user, UserEntity.fromJson);

Future<void> _cacheUser(UserEntity? user) => cacheObject(_Keys.user, user);

UserExploreResponse? get _userExploreResponse =>
    getCachedObject(_Keys.userExplore, UserExploreResponse.fromJson);

Future<void> _cacheUserExploreResponse(UserExploreResponse? response) =>
    cacheObject(_Keys.userExplore, response);

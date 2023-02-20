part of cache;

UserEntity? get _user {
  final userId = _getString(_Keys.userId);
  final cognitoId = _getString(_Keys.userCognitoId);
  final gymId = _getString(_Keys.gymId);
  final confirmed = _getBool(_Keys.userConfirmed);
  final firstName = _getString(_Keys.userFirstName);
  final lastName = _getString(_Keys.userLastName);
  final email = _getString(_Keys.email);
  if (userId != null &&
      cognitoId != null &&
      gymId != null &&
      confirmed != null &&
      firstName != null &&
      lastName != null &&
      email != null) {
    return UserEntity(
      id: userId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      cognitoId: cognitoId,
      gymId: gymId,
      confirmed: confirmed,
    );
  } else {
    return null;
  }
}

ProfilePicturePublicUserEntity? _publicUser(String id) {
  final userId = _getString("$id.${_Keys.userId}");
  final cognitoId = _getString("$id.${_Keys.userCognitoId}");
  final gymId = _getString("$id.${_Keys.gymId}");
  final confirmed = _getBool("$id.${_Keys.userConfirmed}");
  final firstName = _getString("$id.${_Keys.userFirstName}");
  final lastName = _getString("$id.${_Keys.userLastName}");
  final profilePictureUrl = _getUserProfilePictureUrl(id);
  if (userId != null &&
      cognitoId != null &&
      gymId != null &&
      confirmed != null &&
      firstName != null &&
      profilePictureUrl != null &&
      lastName != null) {
    return ProfilePicturePublicUserEntity(
      profilePictureUrl: profilePictureUrl,
      id: userId,
      firstName: firstName,
      lastName: lastName,
      cognitoId: cognitoId,
      gymId: gymId,
      confirmed: confirmed,
    );
  } else {
    return null;
  }
}

Future<bool> _cachePublicUser(ProfilePicturePublicUserEntity? user) =>
    Future.wait([
      _cacheString("${user?.id}.${_Keys.userId}", user?.id),
      _cacheString("${user?.id}.${_Keys.userCognitoId}", user?.cognitoId),
      _cacheString("${user?.id}.${_Keys.userFirstName}", user?.firstName),
      _cacheString("${user?.id}.${_Keys.userLastName}", user?.lastName),
      ...(user != null
          ? [_cacheUserProfilePictureUrl(user.id, user.profilePictureUrl)]
          : []),
      _cacheString("${user?.id}.${_Keys.gymId}", user?.gymId),
      _cacheBool("${user?.id}.${_Keys.userConfirmed}", user?.confirmed),
    ]).then((_) => true);

Future<bool> _cacheUser(UserEntity? user) => Future.wait([
      _cacheString(_Keys.userId, user?.id),
      _cacheString(_Keys.userCognitoId, user?.cognitoId),
      _cacheString(_Keys.userFirstName, user?.firstName),
      _cacheString(_Keys.userLastName, user?.lastName),
      _cacheString(_Keys.email, user?.email),
      _cacheString(_Keys.gymId, user?.gymId),
      _cacheBool(_Keys.userConfirmed, user?.confirmed),
    ]).then((_) => true);

UserExploreResponse? get _userExploreResponse {
  final ids = _getStringList(_Keys.userExploreIds);
  if (ids != null) {
    final List<ProfilePicturePublicUserEntity> users = ids
        .map(
          (id) => _publicUser(id),
        )
        .where((user) => user != null)
        .cast<ProfilePicturePublicUserEntity>()
        .toList();
    final friendRequestIds = _getStringList(_Keys.userExploreFriendRequestIds);
    if (friendRequestIds != null) {
      return UserExploreResponse(
        users: users,
        requests: friendRequestIds
            .map(
              (id) => _getFriendRequest(id),
            )
            .where((friendRequest) => friendRequest != null)
            .cast<FriendRequestEntity>()
            .toList(),
      );
    }
  }
  return null;
}

Future<bool> _cacheUserExploreResponse(UserExploreResponse? response) =>
    Future.wait([
      _cacheStringList(
          _Keys.userExploreIds,
          response?.users
              .map((user) => user.id)
              .toList(growable: false)
              .cast<String>()),
      _cacheStringList(_Keys.userExploreFriendRequestIds,
          response?.requests.map((request) => request.id).toList()),
      ...response?.requests
              .map((request) => _cacheFriendRequest(request.id, request))
              .toList() ??
          [],
      ...response?.users.map((user) => _cachePublicUser(user)).toList() ?? [],
    ]).then((_) => true);

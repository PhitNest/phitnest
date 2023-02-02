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

Future<bool> _cacheUser(UserEntity? user) => Future.wait([
      _cacheString(_Keys.userId, user?.id),
      _cacheString(_Keys.userCognitoId, user?.cognitoId),
      _cacheString(_Keys.userFirstName, user?.firstName),
      _cacheString(_Keys.userLastName, user?.lastName),
      _cacheString(_Keys.email, user?.email),
      _cacheString(_Keys.gymId, user?.gymId),
      _cacheBool(_Keys.userConfirmed, user?.confirmed),
    ]).then((_) => true);

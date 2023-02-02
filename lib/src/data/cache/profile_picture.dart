part of cache;

String? get _profilePictureUrl => _getString(_Keys.profilePictureUrl);

Future<bool> _cacheProfilePictureUrl(String? profilePictureUrl) =>
    _cacheString(_Keys.profilePictureUrl, profilePictureUrl);

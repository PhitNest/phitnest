part of cache;

String? get _profilePictureUrl => getCachedString(_Keys.profilePicture);

Future<void> _cacheProfilePictureUrl(String? profilePictureUrl) =>
    cacheString(_Keys.profilePicture, profilePictureUrl);

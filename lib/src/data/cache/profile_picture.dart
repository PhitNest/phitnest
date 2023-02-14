part of cache;

String? get _profilePictureUrl => _getString(_Keys.profilePictureUrl);

String? _getUserProfilePictureUrl(String userId) =>
    _getString("$userId.${_Keys.profilePictureUrl}");

Future<bool> _cacheProfilePictureUrl(String? profilePictureUrl) =>
    _cacheString(_Keys.profilePictureUrl, profilePictureUrl);

Future<bool> _cacheUserProfilePictureUrl(
        String userId, String? profilePictureUrl) =>
    _cacheString("$userId.${_Keys.profilePictureUrl}", profilePictureUrl);

part of cache;

class _ProfilePictureCache {
  static const kProfilePicture = 'profilePicture';

  const _ProfilePictureCache();

  String? get profilePictureUrl => getCachedString(kProfilePicture);

  Future<void> cacheProfilePictureUrl(String? profilePictureUrl) =>
      cacheString(kProfilePicture, profilePictureUrl);

  String get profilePictureImageCacheKey => 'profilePictureImage';

  String getUserProfilePictureImageCacheKey(String userId) =>
      '$userId.$profilePictureImageCacheKey';
}

part of cache;

class _AuthCache {
  static const kAccessToken = 'accessToken';
  static const kRefreshToken = 'refreshToken';
  static const kPassword = 'password';

  const _AuthCache();

  String? get accessToken => getCachedString(kAccessToken);

  Future<void> cacheAccessToken(String? accessToken) =>
      cacheString(kAccessToken, accessToken);

  String? get refreshToken => getCachedString(kRefreshToken);

  Future<void> cacheRefreshToken(String? refreshToken) =>
      cacheString(kRefreshToken, refreshToken);

  String? get password => getCachedString(kPassword);

  Future<void> cachePassword(String? password) =>
      cacheString(kPassword, password);
}

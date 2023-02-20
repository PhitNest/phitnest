part of cache;

String? get _accessToken => getCachedString(_Keys.accessToken);

Future<void> _cacheAccessToken(String? accessToken) =>
    cacheString(_Keys.accessToken, accessToken);

String? get _refreshToken => getCachedString(_Keys.refreshToken);

Future<void> _cacheRefreshToken(String? refreshToken) =>
    cacheString(_Keys.refreshToken, refreshToken);

String? get _password => getCachedString(_Keys.password);

Future<void> _cachePassword(String? password) =>
    cacheString(_Keys.password, password);

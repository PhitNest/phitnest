part of cache;

String? get _accessToken => _getString(_Keys.accessToken);

Future<bool> _cacheAccessToken(String? accessToken) =>
    _cacheString(_Keys.accessToken, accessToken);

String? get _refreshToken => _getString(_Keys.refreshToken);

Future<bool> _cacheRefreshToken(String? refreshToken) =>
    _cacheString(_Keys.refreshToken, refreshToken);

String? get _password => _getString(_Keys.password);

Future<bool> _cachePassword(String? password) =>
    _cacheString(_Keys.password, password);

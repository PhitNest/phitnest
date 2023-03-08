mixin IAuthCredentialsEntity {
  String get accessToken;
  String get idToken;
  String get refreshToken;
  int get accessTokenExpiresAt;
  int get idTokenExpiresAt;
  int? get clockDrift;
  bool get invalidated;

  /// Checks to see if the session is still valid based on session expiry information found
  /// in tokens and the current time (adjusted with clock drift)
  bool isValid() {
    if (invalidated) {
      return false;
    }
    final now = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    final adjusted = now - clockDrift!;

    return adjusted < accessTokenExpiresAt && adjusted < idTokenExpiresAt;
  }
}

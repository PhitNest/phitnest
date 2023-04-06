import '../auth.dart';

const kIdTokenJsonKey = 'id_token';
const kAccessTokenJsonKey = 'access_token';
const kRefreshTokenJsonKey = 'refresh_token';
const kAccessTokenExpiresJsonKey = 'access_token_expires_at';
const kIdTokenExpiresJsonKey = 'id_token_expires_at';
const kRefreshTokenExpiresJsonKey = 'refresh_token_expires_at';
const kClockDriftJsonKey = 'clock_drift';
const kInvalidatedJsonKey = 'invalidated';

class CognitoTokens extends Tokens {
  final String idToken;
  final String accessToken;
  final String refreshToken;
  final int accessTokenExpiresAt;
  final int idTokenExpiresAt;
  final int? clockDrift;
  final bool invalidated;

  /// Checks to see if the session is still valid based on session expiry information found
  /// in tokens and the current time (adjusted with clock drift)
  bool get isValid {
    if (invalidated) {
      return false;
    }
    final now = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    final adjusted = now - clockDrift!;

    return adjusted < accessTokenExpiresAt && adjusted < idTokenExpiresAt;
  }

  const CognitoTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
    required this.accessTokenExpiresAt,
    required this.idTokenExpiresAt,
    this.clockDrift,
    this.invalidated = false,
  }) : super();

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        idToken,
        accessTokenExpiresAt,
        idTokenExpiresAt,
        clockDrift,
        invalidated,
      ];

  factory CognitoTokens.fromJson(Map<String, dynamic> json) => CognitoTokens(
        accessToken: json[kAccessTokenJsonKey],
        refreshToken: json[kRefreshTokenJsonKey],
        idToken: json[kIdTokenJsonKey],
        accessTokenExpiresAt: json[kAccessTokenExpiresJsonKey],
        idTokenExpiresAt: json[kIdTokenExpiresJsonKey],
        clockDrift: json[kClockDriftJsonKey],
        invalidated: json[kInvalidatedJsonKey],
      );

  @override
  Map<String, dynamic> toJson() => {
        kAccessTokenJsonKey: accessToken,
        kRefreshTokenJsonKey: refreshToken,
        kIdTokenJsonKey: idToken,
        kAccessTokenExpiresJsonKey: accessTokenExpiresAt,
        kIdTokenExpiresJsonKey: idTokenExpiresAt,
        kClockDriftJsonKey: clockDrift,
        kInvalidatedJsonKey: invalidated,
      };
}

part of 'cognito.dart';

class Session extends Equatable {
  final CognitoUser user;
  final CognitoUserSession session;

  const Session(this.user, this.session) : super();

  @override
  List<Object?> get props => [user, session];
}

const kEmailJsonKey = 'email';

Future<void> _cacheEmail(
  String email,
) =>
    cacheSecureString(
      kEmailJsonKey,
      email,
    );

String? _getCachedEmail() => getCachedSecureString(
      kEmailJsonKey,
    );

Future<Session?> _restorePreviousSession(bool admin) async {
  try {
    final cognitoDetails = _getCachedPools();
    final cachedEmail = _getCachedEmail();
    if (cognitoDetails != null && cachedEmail != null) {
      final pool = admin ? cognitoDetails.adminPool : cognitoDetails.userPool;
      final user = CognitoUser(cachedEmail, pool);
      final session = await user.getSession();
      if (session != null) {
        return Session(user, session);
      }
    }
  } catch (err) {
    return null;
  }
  return null;
}

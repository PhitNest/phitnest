part of 'cognito.dart';

class Session extends Equatable {
  final CognitoUser user;
  final CognitoUserSession session;
  final CognitoCredentials credentials;
  final String identityPoolId;
  final String userId;
  final String userBucketName;

  const Session({
    required this.user,
    required this.session,
    required this.credentials,
    required this.identityPoolId,
    required this.userId,
    required this.userBucketName,
  }) : super();

  @override
  List<Object?> get props => [
        user,
        session,
        credentials,
        identityPoolId,
        userId,
        userBucketName,
      ];
}

const kEmailJsonKey = 'email';

Future<void> _cacheEmail(
  String? email,
) =>
    cacheSecureString(
      kEmailJsonKey,
      email,
    );

String? _getCachedEmail() => getCachedSecureString(
      kEmailJsonKey,
    );

const kUserBucketJsonKey = 'userBucketName';

Future<Session?> _restorePreviousSession(bool admin) async {
  try {
    final cognitoDetails = _getCachedPools();
    final cachedEmail = _getCachedEmail();
    final userBucketName = getCachedString(kUserBucketJsonKey);
    if (cognitoDetails != null &&
        cachedEmail != null &&
        userBucketName != null) {
      final pool = admin ? cognitoDetails.adminPool : cognitoDetails.userPool;
      final user = CognitoUser(cachedEmail, pool);
      final session = await user.getSession();
      if (session != null) {
        final credentials = CognitoCredentials(
          cognitoDetails.identityPoolId,
          pool,
        );
        await credentials.getAwsCredentials(session.getIdToken().getJwtToken());
        return Session(
          user: user,
          session: session,
          credentials: credentials,
          identityPoolId: cognitoDetails.identityPoolId,
          userId: session.getAccessToken().getSub()!,
          userBucketName: userBucketName,
        );
      }
    }
  } catch (err) {
    return null;
  }
  return null;
}

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:equatable/equatable.dart';

import '../../../config/aws.dart';
import '../../logger.dart';
import '../aws.dart';

part 'response.dart';

Future<RefreshSessionResponse> _handleRefreshFailures(
  Future<RefreshSessionResponse> Function() refresher,
) async {
  try {
    return await refresher();
  } on CognitoClientException catch (e) {
    error(e.toString());
    return switch (e.code) {
      'ResourceNotFoundException' => const RefreshSessionKnownFailure(
          RefreshSessionFailureType.invalidUserPool),
      'NotAuthorizedException' => const RefreshSessionKnownFailure(
          RefreshSessionFailureType.invalidToken),
      'UserNotFoundException' =>
        const RefreshSessionKnownFailure(RefreshSessionFailureType.noSuchUser),
      _ => RefreshSessionUnknownFailure(message: e.message),
    };
  } on ArgumentError catch (e) {
    error(e.toString());
    return const RefreshSessionKnownFailure(
        RefreshSessionFailureType.invalidUserPool);
  } catch (e) {
    error(e.toString());
    return RefreshSessionUnknownFailure(message: e.toString());
  }
}

Future<RefreshSessionResponse> refreshSession(Session session) async {
  return await _handleRefreshFailures(
    () async {
      final newUserSession = await session.user
          .refreshSession(session.cognitoSession.refreshToken!);
      if (newUserSession != null) {
        await session.credentials.getAwsCredentials(
            session.cognitoSession.getIdToken().getJwtToken());
        return RefreshSessionSuccess(
          Session(
            user: session.user,
            cognitoSession: newUserSession,
            credentials: session.credentials,
          ),
        );
      }
      return RefreshSessionUnknownFailure(message: null);
    },
  );
}

Future<RefreshSessionResponse> getPreviousSession() async {
  return await _handleRefreshFailures(
    () async {
      final user = await userPool.getCurrentUser();
      if (user != null) {
        final session = await user.getSession();
        if (session != null) {
          final credentials = CognitoCredentials(
            kIdentityPoolId,
            userPool,
          );
          await credentials
              .getAwsCredentials(session.getIdToken().getJwtToken());
          return RefreshSessionSuccess(
            Session(
              user: user,
              cognitoSession: session,
              credentials: credentials,
            ),
          );
        }
      }
      return RefreshSessionUnknownFailure(message: null);
    },
  );
}

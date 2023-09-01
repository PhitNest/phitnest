part of 'aws.dart';

sealed class RefreshSessionResponse extends Equatable {
  const RefreshSessionResponse();
}

final class RefreshSessionSuccess extends RefreshSessionResponse {
  final Session newSession;

  const RefreshSessionSuccess(this.newSession) : super();

  @override
  List<Object?> get props => [newSession];
}

sealed class RefreshSessionFailureResponse extends RefreshSessionResponse {
  String get message;

  const RefreshSessionFailureResponse() : super();
}

final class SessionReset extends RefreshSessionFailureResponse {
  @override
  String get message => 'You have been logged out.';

  const SessionReset() : super();

  @override
  List<Object?> get props => [];
}

enum RefreshSessionFailureType {
  invalidUserPool,
  noSuchUser,
  invalidToken;

  String get message => switch (this) {
        RefreshSessionFailureType.invalidUserPool => kInvalidPool,
        RefreshSessionFailureType.noSuchUser => kNoSuchUser,
        RefreshSessionFailureType.invalidToken => 'Invalid token.'
      };
}

final class RefreshSessionFailure extends RefreshSessionFailureResponse {
  @override
  String get message => type.message;

  final RefreshSessionFailureType type;

  const RefreshSessionFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class RefreshSessionUnknownResponse
    extends RefreshSessionFailureResponse {
  @override
  final String message;

  const RefreshSessionUnknownResponse({
    required String? message,
  })  : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}

Future<RefreshSessionResponse> _handleRefreshFailures(
  Future<RefreshSessionResponse> Function() refresher,
) async {
  try {
    return await refresher();
  } on CognitoClientException catch (e) {
    error(e.toString());
    return switch (e.code) {
      'ResourceNotFoundException' =>
        const RefreshSessionFailure(RefreshSessionFailureType.invalidUserPool),
      'NotAuthorizedException' =>
        const RefreshSessionFailure(RefreshSessionFailureType.invalidToken),
      'UserNotFoundException' =>
        const RefreshSessionFailure(RefreshSessionFailureType.noSuchUser),
      _ => RefreshSessionUnknownResponse(message: e.message),
    };
  } on ArgumentError catch (e) {
    error(e.toString());
    return const RefreshSessionFailure(
        RefreshSessionFailureType.invalidUserPool);
  } catch (e) {
    error(e.toString());
    return RefreshSessionUnknownResponse(message: e.toString());
  }
}

Future<RefreshSessionResponse> refreshSession(Session session) async {
  return await _handleRefreshFailures(
    () async {
      final newUserSession = await session.user
          .refreshSession(session.cognitoSession.refreshToken!);
      if (newUserSession != null) {
        if (!session.apiInfo.useAdmin) {
          await session.credentials.getAwsCredentials(
              session.cognitoSession.getIdToken().getJwtToken());
        }
        return RefreshSessionSuccess(
          Session(
            user: session.user,
            cognitoSession: newUserSession,
            credentials: session.credentials,
            apiInfo: session.apiInfo,
          ),
        );
      }
      return RefreshSessionUnknownResponse(message: null);
    },
  );
}

Future<RefreshSessionResponse> getPreviousSession(ApiInfo apiInfo) async {
  return await _handleRefreshFailures(
    () async {
      final user = await apiInfo.pool.getCurrentUser();
      if (user != null) {
        final session = await user.getSession();
        if (session != null) {
          final credentials = CognitoCredentials(
            apiInfo.identityPoolId,
            apiInfo.pool,
          );
          if (!apiInfo.useAdmin) {
            await credentials
                .getAwsCredentials(session.getIdToken().getJwtToken());
          }
          return RefreshSessionSuccess(
            Session(
              user: user,
              cognitoSession: session,
              credentials: credentials,
              apiInfo: apiInfo,
            ),
          );
        }
      }
      return RefreshSessionUnknownResponse(message: null);
    },
  );
}

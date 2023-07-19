part of 'cognito.dart';

sealed class RefreshSessionResponse extends Equatable {
  const RefreshSessionResponse();
}

final class RefreshSessionSuccess extends RefreshSessionResponse {
  final Session newSession;

  RefreshSessionSuccess(this.newSession) : super();

  @override
  List<Object?> get props => [newSession];
}

sealed class RefreshSessionFailureResponse extends RefreshSessionResponse {
  String get message;

  const RefreshSessionFailureResponse() : super();
}

enum RefreshSessionFailureType {
  invalidUserPool,
  noSuchUser,
  invalidToken,
  unknown;

  String get message => switch (this) {
        RefreshSessionFailureType.invalidUserPool => kInvalidPool,
        RefreshSessionFailureType.noSuchUser => kNoSuchUser,
        RefreshSessionFailureType.invalidToken => 'Invalid token.',
        RefreshSessionFailureType.unknown => kUnknownError,
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
  } on CognitoClientException catch (error) {
    return switch (error.code) {
      'ResourceNotFoundException' =>
        RefreshSessionFailure(RefreshSessionFailureType.invalidUserPool),
      'NotAuthorizedException' =>
        RefreshSessionFailure(RefreshSessionFailureType.invalidToken),
      'UserNotFoundException' =>
        RefreshSessionFailure(RefreshSessionFailureType.noSuchUser),
      _ => RefreshSessionUnknownResponse(message: error.message),
    };
  } on ArgumentError catch (_) {
    return RefreshSessionFailure(RefreshSessionFailureType.invalidUserPool);
  } catch (error) {
    return RefreshSessionUnknownResponse(message: error.toString());
  }
}

final class UnauthenticatedSession extends Equatable {
  final CognitoUser user;
  final ApiInfo apiInfo;

  UnauthenticatedSession({
    required this.user,
    required this.apiInfo,
  }) : super();

  @override
  List<Object?> get props => [user, apiInfo];
}

final class Session extends UnauthenticatedSession {
  final CognitoCredentials credentials;
  final CognitoUserSession cognitoSession;

  Session({
    required super.user,
    required super.apiInfo,
    required this.cognitoSession,
    required this.credentials,
  }) : super();

  Future<RefreshSessionResponse> refreshSession() async {
    return await _handleRefreshFailures(
      () async {
        final newUserSession =
            await user.refreshSession(cognitoSession.refreshToken!);
        if (newUserSession != null) {
          if (!apiInfo.useAdmin) {
            await credentials
                .getAwsCredentials(cognitoSession.getIdToken().getJwtToken());
          }
          return RefreshSessionSuccess(
            Session(
              user: user,
              cognitoSession: newUserSession,
              credentials: credentials,
              apiInfo: apiInfo,
            ),
          );
        }
        return RefreshSessionUnknownResponse(message: null);
      },
    );
  }

  @override
  List<Object?> get props => [super.props, cognitoSession, credentials];
}

Future<RefreshSessionResponse> getPreviousSession(
  ApiInfo apiInfo,
) async {
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

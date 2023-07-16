part of 'cognito.dart';

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

final class Session extends Equatable {
  final CognitoUser user;
  final CognitoCredentials credentials;
  final ApiInfo apiInfo;
  final CognitoUserSession cognitoSession;

  Session({
    required this.user,
    required this.cognitoSession,
    required this.credentials,
    required this.apiInfo,
  }) : super();

  Future<RefreshSessionResponse> refreshSession() async {
    try {
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
      } else {
        return RefreshSessionUnknownResponse(message: null);
      }
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

  @override
  List<Object?> get props => [
        user,
        cognitoSession,
        credentials,
        apiInfo,
      ];
}

Future<Session?> getPreviousSession(
  ApiInfo apiInfo,
) async {
  final user = await apiInfo.pool.getCurrentUser();
  if (user != null) {
    final session = await user.getSession();
    if (session != null) {
      final credentials = CognitoCredentials(
        apiInfo.identityPoolId,
        apiInfo.pool,
      );
      if (!apiInfo.useAdmin) {
        await credentials.getAwsCredentials(session.getIdToken().getJwtToken());
      }
      return Session(
        user: user,
        cognitoSession: session,
        credentials: credentials,
        apiInfo: apiInfo,
      );
    }
  }
  return null;
}

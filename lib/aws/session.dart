part of 'aws.dart';

final class UnauthenticatedSession extends Equatable {
  final CognitoUser user;
  final ApiInfo apiInfo;

  const UnauthenticatedSession({
    required this.user,
    required this.apiInfo,
  }) : super();

  @override
  List<Object?> get props => [user, apiInfo];
}

final class Session extends UnauthenticatedSession {
  final CognitoCredentials credentials;
  final CognitoUserSession cognitoSession;

  const Session({
    required super.user,
    required super.apiInfo,
    required this.cognitoSession,
    required this.credentials,
  }) : super();

  @override
  List<Object?> get props => [
        ...super.props,
        cognitoSession,
        credentials,
      ];
}

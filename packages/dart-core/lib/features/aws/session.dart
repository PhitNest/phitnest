import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:equatable/equatable.dart';

final class UnauthenticatedSession extends Equatable {
  final CognitoUser user;

  const UnauthenticatedSession({
    required this.user,
  }) : super();

  @override
  List<Object?> get props => [user];
}

final class Session extends UnauthenticatedSession {
  final CognitoCredentials credentials;
  final CognitoUserSession cognitoSession;

  const Session({
    required super.user,
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

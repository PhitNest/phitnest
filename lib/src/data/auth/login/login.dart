import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:phitnest_utils/utils.dart';

import '../../../entities/entities.dart';
import 'failure.dart';

Future<Either3<AuthCredentialsEntity, LoginFailure, NetworkConnectionFailure>>
    login({
  required String email,
  required String password,
  required CognitoCredentialsEntity cognitoCredentials,
}) async {
  try {
    final userPool = CognitoUserPool(
      cognitoCredentials.userPoolId,
      cognitoCredentials.clientId,
    );
    final cognitoUser = CognitoUser(email, userPool);
    final authResponse = await cognitoUser.authenticateUser(
      AuthenticationDetails(
        username: email,
        password: password,
      ),
    );
    if (authResponse != null) {
      final accessToken = authResponse.accessToken.getJwtToken();
      final idToken = authResponse.idToken.getJwtToken();
      final refreshToken = authResponse.refreshToken?.token;
      if (accessToken != null && idToken != null && refreshToken != null) {
        return Alpha(
          AuthCredentialsEntity(
            accessToken: accessToken,
            idToken: idToken,
            refreshToken: refreshToken,
            accessTokenExpiresAt: authResponse.accessToken.getExpiration(),
            idTokenExpiresAt: authResponse.idToken.getExpiration(),
            clockDrift: authResponse.clockDrift,
          ),
        );
      }
    }
    return Beta(const LoginFailure.unknown());
  } on CognitoUserConfirmationNecessaryException catch (_) {
    return Beta(const LoginFailure.confirmationRequired());
  } on CognitoClientException catch (error) {
    switch (error.code) {
      case "ResourceNotFoundException":
        return Beta(const LoginFailure.invalidCognitoPool());
      case "NotAuthorizedException":
        return Beta(const LoginFailure.invalidLogin());
      case "UserNotFoundException":
        return Beta(const LoginFailure.userNotFound());
      default:
        return Beta(const LoginFailure.unknown());
    }
  } on ArgumentError catch (_) {
    return Beta(const LoginFailure.invalidCognitoPool());
  }
}

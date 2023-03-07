import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:phitnest_utils/utils.dart';

import '../../../domain/entities/entities.dart';
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
          ),
        );
      }
    }
    return Beta(const LoginFailure.unknown());
  } on CognitoUserConfirmationNecessaryException catch (_) {
    return Beta(const LoginFailure.confirmationRequired());
  } on CognitoClientException catch (error) {
    return Beta(
      Function.apply(
        () {
          switch (error.code) {
            case "ResourceNotFoundException":
              return const LoginFailure.invalidCognitoPool();
            case "NotAuthorizedException":
              return const LoginFailure.invalidLogin();
            case "UserNotFoundException":
              return const LoginFailure.userNotFound();
            default:
              return const LoginFailure.unknown();
          }
        },
        [],
      ),
    );
  } on ArgumentError catch (_) {
    return Beta(const LoginFailure.invalidCognitoPool());
  }
}

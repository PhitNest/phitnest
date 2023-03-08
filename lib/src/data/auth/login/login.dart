import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dartz/dartz.dart';
import 'package:phitnest_utils/utils.dart';

import '../../../entities/entities.dart';
import 'response/response.dart';

export './response/response.dart';

Future<Either<LoginResponse, NetworkConnectionFailure>> login({
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
        return Left(
          LoginResponse.success(
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
    return Right(const NetworkConnectionFailure());
  } on CognitoUserConfirmationNecessaryException catch (_) {
    return Left(const LoginResponse.confirmationRequired());
  } on CognitoClientException catch (error) {
    switch (error.code) {
      case "ResourceNotFoundException":
        return Left(const LoginResponse.invalidCognitoPool());
      case "NotAuthorizedException":
        return Left(const LoginResponse.invalidLogin());
      case "UserNotFoundException":
        return Left(const LoginResponse.userNotFound());
      default:
        return Right(const NetworkConnectionFailure());
    }
  } on ArgumentError catch (_) {
    return Left(const LoginResponse.invalidCognitoPool());
  }
}

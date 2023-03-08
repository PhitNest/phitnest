import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dartz/dartz.dart';
import 'package:phitnest_utils/utils.dart';

import '../../../entities/entities.dart';
import 'response/response.dart';

export './response/response.dart';

Future<Either<RegisterResponse, NetworkConnectionFailure>> register({
  required String email,
  required String password,
  required CognitoCredentialsEntity cognitoCredentials,
}) async {
  try {
    final userPool = CognitoUserPool(
      cognitoCredentials.userPoolId,
      cognitoCredentials.clientId,
    );
    final signUpResult =
        await userPool.signUp(email, password, userAttributes: [
      AttributeArg(name: "email", value: email),
    ]);
    if (signUpResult.userSub != null) {
      return Left(RegisterResponse.success(signUpResult.userSub!));
    }
    return Right(const NetworkConnectionFailure());
  } on CognitoClientException catch (error) {
    switch (error.code) {
      case "ResourceNotFoundException":
        return Left(const RegisterResponse.invalidCognitoPool());
      case "UsernameExistsException":
        return Left(const RegisterResponse.userExists());
      case "InvalidPasswordException":
        return Left(RegisterResponse.invalidPassword(
            message: error.message ?? "Invalid password"));
      case "InvalidParameterException":
        return Left(RegisterResponse.invalidEmail(
            message: error.message ?? "Invalid parameter"));
      default:
        print(error);
        return Right(const NetworkConnectionFailure());
    }
  } on ArgumentError catch (_) {
    return Left(const RegisterResponse.invalidCognitoPool());
  }
}

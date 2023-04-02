import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../auth.dart';

export './response/response.dart';

Future<RegisterResponse> register({
  required String email,
  required String password,
  required ServerStatus serverStatus,
}) =>
    serverStatus.when(
      live: (userPoolId, clientId) async {
        try {
          return await CognitoUserPool(
            userPoolId,
            clientId,
          ).signUp(email, password, userAttributes: [
            AttributeArg(name: "email", value: email),
          ]).then(
            (signUpResult) => signUpResult.userSub != null
                ? RegisterResponse.success(signUpResult.userSub!)
                : const RegisterResponse.unknown(),
          );
        } on CognitoClientException catch (error) {
          switch (error.code) {
            case "ResourceNotFoundException":
              return const RegisterResponse.invalidCognitoPool();
            case "UsernameExistsException":
              return const RegisterResponse.userExists();
            case "InvalidPasswordException":
              return RegisterResponse.invalidPassword(
                  message: error.message ?? "Invalid password");
            case "InvalidParameterException":
              return RegisterResponse.invalidEmail(
                  message: error.message ?? "Invalid parameter");
            default:
              return RegisterResponse.unknown(
                message: error.message ?? "An unknown error has occurred",
              );
          }
        } on ArgumentError catch (_) {
          return const RegisterResponse.invalidCognitoPool();
        }
      },
      sandbox: () => Future.value(const RegisterResponse.sandbox()),
    );

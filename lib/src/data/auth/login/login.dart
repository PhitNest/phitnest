import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../auth.dart';

export './response/response.dart';

Future<LoginResponse> login({
  required String email,
  required String password,
  required ServerStatus serverStatus,
}) =>
    serverStatus.when(
      live: (userPoolId, clientId) async {
        try {
          return await CognitoUser(
            email,
            CognitoUserPool(userPoolId, clientId),
          )
              .authenticateUser(
            AuthenticationDetails(
              username: email,
              password: password,
            ),
          )
              .then(
            (authResponse) {
              if (authResponse != null) {
                final accessToken = authResponse.accessToken.getJwtToken();
                final idToken = authResponse.idToken.getJwtToken();
                final refreshToken = authResponse.refreshToken?.token;
                if (accessToken != null &&
                    idToken != null &&
                    refreshToken != null) {
                  return LoginResponse.success(
                    accessToken: accessToken,
                    idToken: idToken,
                    refreshToken: refreshToken,
                    accessTokenExpiresAt:
                        authResponse.accessToken.getExpiration(),
                    idTokenExpiresAt: authResponse.idToken.getExpiration(),
                    clockDrift: authResponse.clockDrift,
                  );
                }
              }

              return const LoginResponse.unknown();
            },
          );
        } on CognitoUserConfirmationNecessaryException catch (_) {
          return const LoginResponse.confirmationRequired();
        } on CognitoClientException catch (error) {
          switch (error.code) {
            case "ResourceNotFoundException":
              return const LoginResponse.invalidCognitoPool();
            case "NotAuthorizedException":
              return const LoginResponse.invalidLogin();
            case "UserNotFoundException":
              return const LoginResponse.userNotFound();
            default:
              return LoginResponse.unknown(
                  message: error.message ?? "An unknown error has occurred");
          }
        } on ArgumentError catch (_) {
          return const LoginResponse.invalidCognitoPool();
        }
      },
      sandbox: () => Future.value(const LoginResponse.sandbox()),
    );

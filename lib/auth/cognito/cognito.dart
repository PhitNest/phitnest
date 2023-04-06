import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:sealed_unions/sealed_unions.dart';

import '../../failure.dart';
import '../auth.dart';
import '../failures.dart';
import 'tokens.dart';

const kInvalidCognitoUserPoolIdMessage = "Invalid Cognito Pool/Client ID";

class Cognito extends Auth {
  final String userPoolId;
  final String clientId;

  const Cognito({
    required this.userPoolId,
    required this.clientId,
  }) : super();

  @override
  List<Object?> get props => [
        userPoolId,
        clientId,
      ];

  @override
  Future<Union4<Tokens, ConfirmationRequired, InvalidEmailPassword, Failure>>
      login(
    String email,
    String password,
  ) async {
    try {
      return await CognitoUser(
        email,
        CognitoUserPool(
          userPoolId,
          clientId,
        ),
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
              return Union4First(
                CognitoTokens(
                  accessToken: accessToken,
                  idToken: idToken,
                  refreshToken: refreshToken,
                  accessTokenExpiresAt:
                      authResponse.accessToken.getExpiration(),
                  idTokenExpiresAt: authResponse.idToken.getExpiration(),
                  clockDrift: authResponse.clockDrift,
                ),
              );
            }
          }

          return Union4Fourth(
            const Failure(kUnknownErrorMessage),
          );
        },
      );
    } on CognitoUserConfirmationNecessaryException catch (_) {
      return Union4Second(const ConfirmationRequired());
    } on CognitoClientException catch (error) {
      switch (error.code) {
        case "ResourceNotFoundException":
          return Union4Fourth(const Failure(kInvalidCognitoUserPoolIdMessage));
        case "NotAuthorizedException":
          return Union4Third(const InvalidEmailPassword());
        case "UserNotFoundException":
          return Union4Fourth(const Failure(kNoSuchUserMessage));
        default:
          return Union4Fourth(
            Failure(error.message ?? kUnknownErrorMessage),
          );
      }
    } on ArgumentError catch (_) {
      return Union4Fourth(const Failure(kInvalidCognitoUserPoolIdMessage));
    }
  }

  @override
  Future<Union5<String, UserExists, InvalidEmail, InvalidPassword, Failure>>
      register(
    String email,
    String password,
  ) async {
    try {
      return await CognitoUserPool(
        userPoolId,
        clientId,
      ).signUp(email, password, userAttributes: [
        AttributeArg(name: "email", value: email),
      ]).then(
        (signUpResult) => signUpResult.userSub != null
            ? Union5First(signUpResult.userSub!)
            : Union5Fifth(const Failure(kUnknownErrorMessage)),
      );
    } on CognitoClientException catch (error) {
      switch (error.code) {
        case "ResourceNotFoundException":
          return Union5Fifth(const Failure(kInvalidCognitoUserPoolIdMessage));
        case "UsernameExistsException":
          return Union5Second(const UserExists());
        case "InvalidPasswordException":
          return Union5Fourth(InvalidPassword(error.message));
        case "InvalidParameterException":
          return Union5Third(InvalidEmail(error.message));
        default:
          return Union5Fifth(Failure(error.message ?? kUnknownErrorMessage));
      }
    } on ArgumentError catch (_) {
      return Union5Fifth(const Failure(kInvalidCognitoUserPoolIdMessage));
    }
  }

  Future<Union2<void, Failure>> confirmEmail(
    String email,
    String code,
  ) async {
    try {
      return await CognitoUser(
        email,
        CognitoUserPool(
          userPoolId,
          clientId,
        ),
      )
          .confirmRegistration(
            code,
          )
          .then(
            (successful) => successful
                ? Union2First(null)
                : Union2Second(const Failure(kIncorrectCodeMessage)),
          );
    } on ArgumentError catch (_) {
      return Union2Second(const Failure(kInvalidCognitoUserPoolIdMessage));
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        "mode": "cognito",
        kUserPoolIdJsonKey: userPoolId,
        kAppClientIdJsonKey: clientId,
      };

  factory Cognito.fromJson(Map<String, dynamic> json) => Cognito(
        userPoolId: json[kUserPoolIdJsonKey],
        clientId: json[kAppClientIdJsonKey],
      );
}

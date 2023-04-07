import 'package:sealed_unions/sealed_unions.dart';

import 'cognito/cognito.dart';
import 'failures.dart';
import 'sandbox/sandbox.dart';

const kUserPoolIdJsonKey = "userPoolId";
const kAppClientIdJsonKey = "clientId";

abstract class Auth {
  const Auth() : super();

  factory Auth.fromServerStatus(dynamic serverStatus) {
    if (serverStatus is String && serverStatus == "sandbox") {
      return Sandbox.getFromCache() ??
          Sandbox(
            emailToUserMap: {},
            idToUserMap: {},
            currentUser: null,
          );
    } else if (serverStatus is Map<String, dynamic> &&
        serverStatus.containsKey(kUserPoolIdJsonKey) &&
        serverStatus.containsKey(kAppClientIdJsonKey)) {
      return Cognito(
        userPoolId: serverStatus[kUserPoolIdJsonKey],
        clientId: serverStatus[kAppClientIdJsonKey],
      );
    }
    throw Exception("Invalid server status: $serverStatus");
  }

  Future<Union2<String, LoginFailure>> login(
    String email,
    String password,
  );

  Future<Union2<String, RegistrationFailure>> register(
    String email,
    String password,
  );

  Future<bool> confirmEmail(String email, String code);

  Future<bool> resendConfirmationEmail(String email);

  Future<Union2<void, ForgotPasswordFailure>> forgotPassword(String email);

  Future<Union2<void, SubmitForgotPasswordFailure>> submitForgotPassword(
    String email,
    String code,
    String newPassword,
  );

  Future<Union2<void, RefreshSessionFailure>> refreshSession();
}

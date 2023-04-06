import 'package:equatable/equatable.dart';
import 'package:sealed_unions/sealed_unions.dart';

import '../failure.dart';
import '../serializable.dart';
import 'cognito/cognito.dart';
import 'failures.dart';
import 'sandbox/sandbox.dart';

export 'cognito/cognito.dart';
export 'sandbox/sandbox.dart';

const kNoSuchUserMessage = "No such user exists";
const kUnknownErrorMessage = "An unknown error has occurred";
const kIncorrectCodeMessage = "Incorrect code";

const kUserPoolIdJsonKey = "userPoolId";
const kAppClientIdJsonKey = "clientId";

abstract class Tokens extends Equatable with Serializable {
  const Tokens() : super();

  bool get isValid;
}

abstract class Auth extends Equatable with Serializable {
  const Auth() : super();

  factory Auth.fromServerStatus(dynamic serverStatus) {
    if (serverStatus is String && serverStatus == "sandbox") {
      return Sandbox.getFromCache() ??
          const Sandbox(
            emailToUserMap: {},
            idToUserMap: {},
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

  Future<Union4<Tokens, ConfirmationRequired, InvalidEmailPassword, Failure>>
      login(
    String email,
    String password,
  );

  Future<Union5<String, UserExists, InvalidEmail, InvalidPassword, Failure>>
      register(
    String email,
    String password,
  );

  Future<Union2<void, Failure>> confirmEmail(
    String email,
    String code,
  );
}

part of 'cognito.dart';

sealed class LoginResponse extends Equatable {
  const LoginResponse() : super();
}

final class LoginSuccess extends LoginResponse {
  final Session session;

  const LoginSuccess({
    required this.session,
  }) : super();

  @override
  List<Object?> get props => [session];
}

enum LoginFailureType {
  invalidEmailPassword,
  noSuchUser,
  invalidUserPool;

  String get message => switch (this) {
        LoginFailureType.invalidEmailPassword => 'Invalid email/password.',
        LoginFailureType.noSuchUser => kNoSuchUser,
        LoginFailureType.invalidUserPool => kInvalidPool,
      };
}

sealed class LoginFailureResponse extends LoginResponse {
  String get message;

  const LoginFailureResponse() : super();
}

final class LoginFailure extends LoginFailureResponse {
  final LoginFailureType type;

  @override
  String get message => type.message;

  const LoginFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class LoginConfirmationRequired extends LoginFailureResponse {
  @override
  String get message => 'Confirmation required.';

  final CognitoUser user;
  final String password;

  const LoginConfirmationRequired({
    required this.user,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [user, password];
}

final class LoginUnknownResponse extends LoginFailureResponse {
  @override
  final String message;

  const LoginUnknownResponse({
    required String? message,
  })  : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}

final class LoginChangePasswordRequired extends LoginFailureResponse {
  final CognitoUser user;

  @override
  String get message => 'Change password required.';

  const LoginChangePasswordRequired(this.user) : super();

  @override
  List<Object?> get props => [user];
}

final class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  }) : super();

  @override
  List<Object> get props => [email, password];
}

Future<LoginResponse> login({
  required LoginParams params,
  required ApiInfo apiInfo,
}) async {
  final user = CognitoUser(params.email, apiInfo.pool);
  try {
    final session = await user.authenticateUser(
      AuthenticationDetails(
        username: params.email,
        password: params.password,
      ),
    );
    if (session != null) {
      final userId = session.accessToken.getSub();
      if (userId != null) {
        final credentials =
            CognitoCredentials(apiInfo.identityPoolId, apiInfo.pool);
        if (!apiInfo.useAdmin) {
          await credentials
              .getAwsCredentials(session.getIdToken().getJwtToken());
        }
        return LoginSuccess(
          session: Session(
            user: user,
            cognitoSession: session,
            credentials: credentials,
            apiInfo: apiInfo,
          ),
        );
      }
    }
    return const LoginUnknownResponse(message: null);
  } on CognitoUserConfirmationNecessaryException catch (_) {
    return LoginConfirmationRequired(user: user, password: params.password);
  } on CognitoClientException catch (error) {
    return switch (error.code) {
      'ResourceNotFoundException' =>
        const LoginFailure(LoginFailureType.invalidUserPool),
      'NotAuthorizedException' =>
        const LoginFailure(LoginFailureType.invalidEmailPassword),
      'UserNotFoundException' =>
        const LoginFailure(LoginFailureType.noSuchUser),
      _ => LoginUnknownResponse(message: error.message),
    };
  } on ArgumentError catch (_) {
    return const LoginFailure(LoginFailureType.invalidUserPool);
  } on CognitoUserNewPasswordRequiredException {
    return LoginChangePasswordRequired(user);
  } catch (err) {
    return LoginUnknownResponse(message: err.toString());
  }
}

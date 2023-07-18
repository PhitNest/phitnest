part of 'cognito.dart';

sealed class ChangePasswordResponse extends Equatable {
  const ChangePasswordResponse() : super();
}

final class ChangePasswordSuccess extends ChangePasswordResponse {
  final Session session;

  const ChangePasswordSuccess(this.session) : super();

  @override
  List<Object?> get props => [session];
}

enum ChangePasswordFailureType {
  invalidUserPool,
  invalidPassword,
  noSuchUser;

  String get message => switch (this) {
        ChangePasswordFailureType.invalidUserPool => kInvalidPool,
        ChangePasswordFailureType.invalidPassword => kInvalidPassword,
        ChangePasswordFailureType.noSuchUser => kNoSuchUser,
      };
}

sealed class ChangePasswordFailureResponse extends ChangePasswordResponse {
  String get message;

  const ChangePasswordFailureResponse() : super();
}

final class ChangePasswordFailure extends ChangePasswordFailureResponse {
  final ChangePasswordFailureType type;

  @override
  String get message => type.message;

  const ChangePasswordFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class ChangePasswordUnknownResponse
    extends ChangePasswordFailureResponse {
  @override
  final String message;

  const ChangePasswordUnknownResponse({
    required String? message,
  })  : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}

final class ChangePasswordUser extends Equatable {
  final CognitoUser user;

  const ChangePasswordUser({
    required this.user,
  }) : super();

  @override
  List<Object?> get props => [user];
}

Future<ChangePasswordResponse> changePassword({
  required ChangePasswordUser user,
  required String newPassword,
  required ApiInfo apiInfo,
}) async {
  try {
    final session = await user.user.sendNewPasswordRequiredAnswer(
      newPassword,
    );
    if (session != null) {
      final credentials = CognitoCredentials(
        apiInfo.identityPoolId,
        user.user.pool,
      );
      if (!apiInfo.useAdmin) {
        await credentials.getAwsCredentials(
          session.getIdToken().getJwtToken(),
        );
      }
      return ChangePasswordSuccess(
        Session(
          user: user.user,
          cognitoSession: session,
          credentials: credentials,
          apiInfo: apiInfo,
        ),
      );
    } else {
      return const ChangePasswordUnknownResponse(message: null);
    }
  } on CognitoClientException catch (error) {
    return switch (error.code) {
      'ResourceNotFoundException' => const ChangePasswordFailure(
          ChangePasswordFailureType.invalidUserPool,
        ),
      'NotAuthorizedException' => const ChangePasswordFailure(
          ChangePasswordFailureType.invalidPassword,
        ),
      'UserNotFoundException' => const ChangePasswordFailure(
          ChangePasswordFailureType.noSuchUser,
        ),
      _ => ChangePasswordUnknownResponse(message: error.message),
    };
  } on ArgumentError catch (_) {
    return const ChangePasswordFailure(
      ChangePasswordFailureType.invalidUserPool,
    );
  } catch (err) {
    return ChangePasswordUnknownResponse(message: err.toString());
  }
}
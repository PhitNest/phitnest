part of 'aws.dart';

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

final class ChangePasswordKnownFailure extends ChangePasswordFailureResponse {
  final ChangePasswordFailureType type;

  @override
  String get message => type.message;

  const ChangePasswordKnownFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class ChangePasswordUnknownFailure extends ChangePasswordFailureResponse {
  @override
  final String message;

  const ChangePasswordUnknownFailure({
    required String? message,
  })  : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}

Future<ChangePasswordResponse> changePassword({
  required String newPassword,
  required UnauthenticatedSession unauthenticatedSession,
}) async {
  try {
    final session =
        await unauthenticatedSession.user.sendNewPasswordRequiredAnswer(
      newPassword,
    );
    if (session != null) {
      final credentials = CognitoCredentials(
        unauthenticatedSession.apiInfo.identityPoolId,
        unauthenticatedSession.user.pool,
      );
      if (!unauthenticatedSession.apiInfo.useAdmin) {
        await credentials.getAwsCredentials(
          session.getIdToken().getJwtToken(),
        );
      }
      return ChangePasswordSuccess(
        Session(
          user: unauthenticatedSession.user,
          cognitoSession: session,
          credentials: credentials,
          apiInfo: unauthenticatedSession.apiInfo,
        ),
      );
    } else {
      return const ChangePasswordUnknownFailure(message: null);
    }
  } on CognitoClientException catch (e) {
    error(e.toString());
    return switch (e.code) {
      'ResourceNotFoundException' => const ChangePasswordKnownFailure(
          ChangePasswordFailureType.invalidUserPool,
        ),
      'NotAuthorizedException' => const ChangePasswordKnownFailure(
          ChangePasswordFailureType.invalidPassword,
        ),
      'UserNotFoundException' => const ChangePasswordKnownFailure(
          ChangePasswordFailureType.noSuchUser,
        ),
      _ => ChangePasswordUnknownFailure(message: e.message),
    };
  } on ArgumentError catch (err) {
    error(err.toString());
    return const ChangePasswordKnownFailure(
      ChangePasswordFailureType.invalidUserPool,
    );
  } catch (err) {
    error(err.toString());
    return ChangePasswordUnknownFailure(message: err.toString());
  }
}

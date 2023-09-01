import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:equatable/equatable.dart';

import '../../../config/aws.dart';
import '../../logger.dart';
import '../aws.dart';

part 'response.dart';

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
        kIdentityPoolId,
        unauthenticatedSession.user.pool,
      );
      await credentials.getAwsCredentials(
        session.getIdToken().getJwtToken(),
      );
      return ChangePasswordSuccess(
        Session(
          user: unauthenticatedSession.user,
          cognitoSession: session,
          credentials: credentials,
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

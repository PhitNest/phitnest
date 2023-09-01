import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:equatable/equatable.dart';

import '../../../config/aws.dart';
import '../../logger.dart';
import '../aws.dart';

part 'response.dart';
part 'params.dart';

Future<LoginResponse> login(LoginParams params) async {
  final user = CognitoUser(params.email, userPool);
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
        final credentials = CognitoCredentials(kIdentityPoolId, userPool);
        await credentials.getAwsCredentials(session.getIdToken().getJwtToken());
        return LoginSuccess(
          session: Session(
            user: user,
            cognitoSession: session,
            credentials: credentials,
          ),
        );
      }
    }
    return const LoginUnknownResponse(message: null);
  } on CognitoUserConfirmationNecessaryException catch (e) {
    error(e.toString());
    return LoginConfirmationRequired(user: user, password: params.password);
  } on CognitoClientException catch (e) {
    error(e.toString());
    return switch (e.code) {
      'ResourceNotFoundException' =>
        const LoginKnownFailure(LoginFailureType.invalidUserPool),
      'NotAuthorizedException' =>
        const LoginKnownFailure(LoginFailureType.invalidEmailPassword),
      'UserNotFoundException' =>
        const LoginKnownFailure(LoginFailureType.noSuchUser),
      _ => LoginUnknownResponse(message: e.message),
    };
  } on ArgumentError catch (e) {
    error(e.toString());
    return const LoginKnownFailure(LoginFailureType.invalidUserPool);
  } on CognitoUserNewPasswordRequiredException catch (e) {
    error(e.toString());
    return LoginChangePasswordRequired(user);
  } catch (err) {
    error(err.toString());
    return LoginUnknownResponse(message: err.toString());
  }
}

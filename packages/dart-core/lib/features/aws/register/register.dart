import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:equatable/equatable.dart';

import '../../logger.dart';
import '../aws.dart';

part 'response.dart';
part 'params.dart';

Future<RegisterResponse> register(
  RegisterParams params,
) async {
  try {
    final signUpResult = await userPool.signUp(
      params.email,
      params.password,
      userAttributes: [
        AttributeArg(name: 'email', value: params.email),
      ],
      validationData: [
        AttributeArg(name: 'firstName', value: params.firstName),
        AttributeArg(name: 'lastName', value: params.lastName),
      ],
    );
    if (signUpResult.userSub != null) {
      return RegisterSuccess(
        signUpResult.user,
        params.password,
      );
    } else {
      return const RegisterUnknownFailure(message: null);
    }
  } on CognitoClientException catch (e) {
    error(e.toString());
    return switch (e.code) {
      'ResourceNotFoundException' =>
        const RegisterKnownFailure((RegisterFailureType.invalidUserPool)),
      'UsernameExistsException' =>
        const RegisterKnownFailure(RegisterFailureType.userExists),
      'InvalidPasswordException' => ValidationFailure(
          e.message ?? 'Invalid password',
        ),
      'InvalidParameterException' =>
        ValidationFailure(e.message ?? 'Invalid email'),
      _ => RegisterUnknownFailure(message: e.message),
    };
  } on ArgumentError catch (e) {
    error(e.toString());
    return const RegisterKnownFailure(RegisterFailureType.invalidUserPool);
  } catch (e) {
    error(e.toString());
    return RegisterUnknownFailure(message: e.toString());
  }
}

part of 'cognito.dart';

sealed class RegisterResponse extends Equatable {
  const RegisterResponse();
}

final class RegisterSuccess extends RegisterResponse {
  final CognitoUser user;
  final String password;

  const RegisterSuccess(
    this.user,
    this.password,
  ) : super();

  @override
  List<Object?> get props => [user, password];
}

sealed class RegisterFailureResponse extends RegisterResponse {
  String get message;

  const RegisterFailureResponse() : super();
}

enum RegisterFailureType {
  userExists,
  invalidUserPool;

  String get message => switch (this) {
        RegisterFailureType.userExists =>
          'A user with that email already exists.',
        RegisterFailureType.invalidUserPool => kInvalidPool,
      };
}

final class RegisterFailure extends RegisterFailureResponse {
  @override
  String get message => type.message;

  final RegisterFailureType type;

  const RegisterFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class ValidationFailure extends RegisterFailureResponse {
  @override
  final String message;

  const ValidationFailure(this.message) : super();

  @override
  List<Object?> get props => [message];
}

final class RegisterUnknownResponse extends RegisterFailureResponse {
  @override
  final String message;

  const RegisterUnknownResponse({
    required String? message,
  })  : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}

Future<RegisterResponse> register({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  required String inviterEmail,
  required CognitoUserPool pool,
}) async {
  try {
    final signUpResult = await pool.signUp(
      email,
      password,
      userAttributes: [
        AttributeArg(name: 'email', value: email),
      ],
      validationData: [
        AttributeArg(name: 'firstName', value: firstName),
        AttributeArg(name: 'lastName', value: lastName),
        AttributeArg(name: 'inviterEmail', value: inviterEmail),
      ],
    );
    if (signUpResult.userSub != null) {
      return RegisterSuccess(
        signUpResult.user,
        password,
      );
    } else {
      return const RegisterUnknownResponse(message: null);
    }
  } on CognitoClientException catch (error) {
    return switch (error.code) {
      'ResourceNotFoundException' =>
        const RegisterFailure((RegisterFailureType.invalidUserPool)),
      'UsernameExistsException' =>
        const RegisterFailure(RegisterFailureType.userExists),
      'InvalidPasswordException' => ValidationFailure(
          error.message ?? 'Invalid password',
        ),
      'InvalidParameterException' =>
        ValidationFailure(error.message ?? 'Invalid email'),
      _ => RegisterUnknownResponse(message: error.message),
    };
  } on ArgumentError catch (_) {
    return const RegisterFailure(RegisterFailureType.invalidUserPool);
  } catch (err) {
    return RegisterUnknownResponse(message: err.toString());
  }
}

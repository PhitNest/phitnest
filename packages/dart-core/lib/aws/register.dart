part of 'aws.dart';

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

final class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        firstName,
        lastName,
      ];
}

Future<RegisterResponse> register({
  required RegisterParams params,
  required CognitoUserPool pool,
}) async {
  try {
    final signUpResult = await pool.signUp(
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
      return const RegisterUnknownResponse(message: null);
    }
  } on CognitoClientException catch (e) {
    error(e.toString());
    return switch (e.code) {
      'ResourceNotFoundException' =>
        const RegisterFailure((RegisterFailureType.invalidUserPool)),
      'UsernameExistsException' =>
        const RegisterFailure(RegisterFailureType.userExists),
      'InvalidPasswordException' => ValidationFailure(
          e.message ?? 'Invalid password',
        ),
      'InvalidParameterException' =>
        ValidationFailure(e.message ?? 'Invalid email'),
      _ => RegisterUnknownResponse(message: e.message),
    };
  } on ArgumentError catch (e) {
    error(e.toString());
    return const RegisterFailure(RegisterFailureType.invalidUserPool);
  } catch (e) {
    error(e.toString());
    return RegisterUnknownResponse(message: e.toString());
  }
}

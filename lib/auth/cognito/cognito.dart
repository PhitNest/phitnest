part of '../auth.dart';

class _CognitoState {
  CognitoUser? user;
  CognitoUserSession? session;
}

class Cognito extends Auth {
  final CognitoUserPool _pool;
  final _CognitoState _state;

  Cognito({
    required String poolId,
    required String clientId,
  })  : _pool = CognitoUserPool(poolId, clientId),
        _state = _CognitoState(),
        super();

  @override
  Map<String, Serializable> toJson() => throw UnimplementedError();

  @override
  Future<LoginResponse> login(
    String email,
    String password,
  ) async {
    try {
      _state.user = CognitoUser(email, _pool);
      _state.session = await _state.user!.authenticateUser(
        AuthenticationDetails(
          username: email,
          password: password,
        ),
      );
      if (_state.session != null) {
        final userId = _state.session!.accessToken.getSub();
        if (userId != null) {
          await _state.user!.cacheTokens();
          return LoginSuccess(userId);
        }
      }
      return const LoginFailure(LoginFailureType.unknown);
    } on CognitoUserConfirmationNecessaryException catch (_) {
      return const LoginFailure(LoginFailureType.confirmationRequired);
    } on CognitoClientException catch (error) {
      return switch (error.code) {
        'ResourceNotFoundException' =>
          const LoginFailure(LoginFailureType.invalidUserPool),
        'NotAuthorizedException' =>
          const LoginFailure(LoginFailureType.invalidEmailPassword),
        'UserNotFoundException' =>
          const LoginFailure(LoginFailureType.noSuchUser),
        _ => const LoginFailure(LoginFailureType.unknown),
      };
    } on ArgumentError catch (_) {
      return const LoginFailure(LoginFailureType.invalidUserPool);
    } catch (_) {
      return const LoginFailure(LoginFailureType.unknown);
    }
  }

  @override
  Future<RegisterResponse> register(
    String email,
    String password,
    List<AttributeArg> userAttributes,
  ) async {
    try {
      final signUpResult = await _pool.signUp(
        email,
        password,
        userAttributes: [
          AttributeArg(name: 'email', value: email),
          ...userAttributes,
        ],
      );
      if (signUpResult.userSub != null) {
        return RegisterSuccess(signUpResult.userSub!);
      } else {
        return const RegisterFailure(RegisterFailureType.unknown);
      }
    } on CognitoClientException catch (error) {
      return switch (error.code) {
        'ResourceNotFoundException' =>
          const RegisterFailure((RegisterFailureType.invalidUserPool)),
        'UsernameExistsException' =>
          const RegisterFailure(RegisterFailureType.userExists),
        'InvalidPasswordException' => ValidationFailure(
            ValidationFailureType.invalidPassword, error.message),
        'InvalidParameterException' =>
          ValidationFailure(ValidationFailureType.invalidEmail, error.message),
        _ => const RegisterFailure(RegisterFailureType.unknown),
      };
    } on ArgumentError catch (_) {
      return const RegisterFailure(RegisterFailureType.invalidUserPool);
    } catch (_) {
      return const RegisterFailure(RegisterFailureType.unknown);
    }
  }

  @override
  Future<bool> confirmEmail(
    String email,
    String code,
  ) =>
      CognitoUser(email, _pool)
          .confirmRegistration(code)
          .catchError((_) => false);

  @override
  Future<bool> resendConfirmationEmail(
    String email,
  ) async {
    final response = CognitoUser(email, _pool).resendConfirmationCode();
    if (response is Future) {
      return await response.then((_) => true).catchError((_) => false);
    } else {
      return false;
    }
  }

  @override
  Future<ForgotPasswordFailure?> forgotPassword(
    String email,
  ) async {
    try {
      await CognitoUser(email, _pool).forgotPassword();
      return null;
    } on CognitoClientException catch (error) {
      return switch (error.code) {
        'ResourceNotFoundException' => ForgotPasswordFailure.invalidUserPool,
        'InvalidParameterException' => ForgotPasswordFailure.invalidEmail,
        'UserNotFoundException' => ForgotPasswordFailure.noSuchUser,
        _ => ForgotPasswordFailure.unknown,
      };
    } on ArgumentError catch (_) {
      return ForgotPasswordFailure.invalidUserPool;
    } catch (_) {
      return ForgotPasswordFailure.unknown;
    }
  }

  @override
  Future<SubmitForgotPasswordFailure?> submitForgotPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      await CognitoUser(email, _pool).confirmPassword(code, newPassword);
      return null;
    } on CognitoClientException catch (error) {
      return switch (error.code) {
        'ResourceNotFoundException' =>
          SubmitForgotPasswordFailure.invalidUserPool,
        'InvalidParameterException' =>
          SubmitForgotPasswordFailure.invalidCodeOrPassword,
        'CodeMismatchException' => SubmitForgotPasswordFailure.invalidCode,
        'ExpiredCodeException' => SubmitForgotPasswordFailure.expiredCode,
        'UserNotFoundException' => SubmitForgotPasswordFailure.noSuchUser,
        _ => SubmitForgotPasswordFailure.unknown,
      };
    } catch (_) {
      return SubmitForgotPasswordFailure.unknown;
    }
  }

  @override
  Future<RefreshSessionFailure?> refreshSession({
    bool admin = false,
  }) async {
    if (_state.user == null) {
      return RefreshSessionFailure.noSuchUser;
    }
    try {
      _state.session =
          await _state.user!.refreshSession(_state.session!.refreshToken!);
      if (_state.session != null) {
        await _state.user!.cacheTokens();
        return null;
      } else {
        return RefreshSessionFailure.unknown;
      }
    } on CognitoClientException catch (error) {
      return switch (error.code) {
        'ResourceNotFoundException' => RefreshSessionFailure.invalidUserPool,
        'NotAuthorizedException' => RefreshSessionFailure.invalidToken,
        'UserNotFoundException' => RefreshSessionFailure.noSuchUser,
        _ => RefreshSessionFailure.unknown,
      };
    } on ArgumentError catch (_) {
      return RefreshSessionFailure.invalidUserPool;
    } catch (_) {
      return RefreshSessionFailure.unknown;
    }
  }
}

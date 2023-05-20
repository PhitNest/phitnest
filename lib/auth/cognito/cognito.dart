part of '../auth.dart';

class _CognitoState {
  CognitoUser? user;
  CognitoUserSession? session;
}

class Cognito extends Auth {
  final CognitoUserPool _pool;
  final _CognitoState _state;

  Cognito(CognitoPoolDetails poolDetails)
      : _pool = CognitoUserPool(poolDetails.userPoolId, poolDetails.clientId),
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
      switch (error.code) {
        case "ResourceNotFoundException":
          return const LoginFailure(LoginFailureType.invalidUserPool);
        case "NotAuthorizedException":
          return const LoginFailure(LoginFailureType.invalidEmailPassword);
        case "UserNotFoundException":
          return const LoginFailure(LoginFailureType.noSuchUser);
        default:
          return const LoginFailure(LoginFailureType.unknown);
      }
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
          AttributeArg(name: "email", value: email),
          ...userAttributes,
        ],
      );
      if (signUpResult.userSub != null) {
        return RegisterSuccess(signUpResult.userSub!);
      } else {
        return const RegisterFailure(RegisterFailureType.unknown);
      }
    } on CognitoClientException catch (error) {
      switch (error.code) {
        case "ResourceNotFoundException":
          return const RegisterFailure((RegisterFailureType.invalidUserPool));
        case "UsernameExistsException":
          return const RegisterFailure(RegisterFailureType.userExists);
        case "InvalidPasswordException":
          return ValidationFailure(
              ValidationFailureType.invalidPassword, error.message);
        case "InvalidParameterException":
          return ValidationFailure(
              ValidationFailureType.invalidEmail, error.message);
        default:
          return const RegisterFailure(RegisterFailureType.unknown);
      }
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
  Future<bool> resendConfirmationEmail(String email) =>
      CognitoUser(email, _pool)
          .resendConfirmationCode()
          .catchError((_) => false);

  @override
  Future<ForgotPasswordFailure?> forgotPassword(String email) async {
    try {
      await CognitoUser(email, _pool).forgotPassword();
      return null;
    } on CognitoClientException catch (error) {
      switch (error.code) {
        case "ResourceNotFoundException":
          return ForgotPasswordFailure.invalidUserPool;
        case "InvalidParameterException":
          return ForgotPasswordFailure.invalidEmail;
        case "UserNotFoundException":
          return ForgotPasswordFailure.noSuchUser;
        default:
          return ForgotPasswordFailure.unknown;
      }
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
      switch (error.code) {
        case "ResourceNotFoundException":
          return SubmitForgotPasswordFailure.invalidUserPool;
        case "InvalidParameterException":
          return SubmitForgotPasswordFailure.invalidCodeOrPassword;
        case "CodeMismatchException":
          return SubmitForgotPasswordFailure.invalidCode;
        case "ExpiredCodeException":
          return SubmitForgotPasswordFailure.expiredCode;
        case "UserNotFoundException":
          return SubmitForgotPasswordFailure.noSuchUser;
        default:
          return SubmitForgotPasswordFailure.unknown;
      }
    } catch (_) {
      return SubmitForgotPasswordFailure.unknown;
    }
  }

  @override
  Future<RefreshSessionFailure?> refreshSession() async {
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
      switch (error.code) {
        case "ResourceNotFoundException":
          return RefreshSessionFailure.invalidUserPool;
        case "NotAuthorizedException":
          return RefreshSessionFailure.invalidToken;
        case "UserNotFoundException":
          return RefreshSessionFailure.noSuchUser;
        default:
          return RefreshSessionFailure.unknown;
      }
    } on ArgumentError catch (_) {
      return RefreshSessionFailure.invalidUserPool;
    } catch (_) {
      return RefreshSessionFailure.unknown;
    }
  }
}

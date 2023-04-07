import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:sealed_unions/sealed_unions.dart';

import '../auth.dart';
import '../failures.dart';

class _CognitoState {
  CognitoUser? user;
  CognitoUserSession? session;
}

class Cognito extends Auth {
  final CognitoUserPool _pool;
  final _CognitoState _state;

  Cognito({
    required String userPoolId,
    required String clientId,
  })  : _pool = CognitoUserPool(userPoolId, clientId),
        _state = _CognitoState(),
        super();

  @override
  Future<Union2<String, LoginFailure>> login(
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
          return Union2First(userId);
        }
      }
      return Union2Second(LoginFailure(LoginFailureType.unknown));
    } on CognitoUserConfirmationNecessaryException catch (_) {
      return Union2Second(LoginFailure(LoginFailureType.confirmationRequired));
    } on CognitoClientException catch (error) {
      switch (error.code) {
        case "ResourceNotFoundException":
          return Union2Second(LoginFailure(LoginFailureType.invalidUserPool));
        case "NotAuthorizedException":
          return Union2Second(
              LoginFailure(LoginFailureType.invalidEmailPassword));
        case "UserNotFoundException":
          return Union2Second(LoginFailure(LoginFailureType.noSuchUser));
        default:
          return Union2Second(LoginFailure(LoginFailureType.unknown));
      }
    } on ArgumentError catch (_) {
      return Union2Second(LoginFailure(LoginFailureType.invalidUserPool));
    } catch (_) {
      return Union2Second(LoginFailure(LoginFailureType.unknown));
    }
  }

  @override
  Future<Union2<String, RegistrationFailure>> register(
    String email,
    String password,
  ) async {
    try {
      final signUpResult = await _pool.signUp(
        email,
        password,
        userAttributes: [
          AttributeArg(name: "email", value: email),
        ],
      );
      if (signUpResult.userSub != null) {
        return Union2First(signUpResult.userSub!);
      } else {
        return Union2Second(
            RegistrationFailure(Union2First(RegistrationFailureType.unknown)));
      }
    } on CognitoClientException catch (error) {
      switch (error.code) {
        case "ResourceNotFoundException":
          return Union2Second(RegistrationFailure(
              Union2First(RegistrationFailureType.invalidUserPool)));
        case "UsernameExistsException":
          return Union2Second(RegistrationFailure(
              Union2First(RegistrationFailureType.userExists)));
        case "InvalidPasswordException":
          return Union2Second(RegistrationFailure(Union2Second(
              ValidationFailure(
                  ValidationFailureType.invalidPassword, error.message))));
        case "InvalidParameterException":
          return Union2Second(RegistrationFailure(Union2Second(
              ValidationFailure(
                  ValidationFailureType.invalidEmail, error.message))));
        default:
          return Union2Second(RegistrationFailure(
              Union2First(RegistrationFailureType.unknown)));
      }
    } on ArgumentError catch (_) {
      return Union2Second(RegistrationFailure(
          Union2First(RegistrationFailureType.invalidUserPool)));
    } catch (_) {
      return Union2Second(
          RegistrationFailure(Union2First(RegistrationFailureType.unknown)));
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
  Future<Union2<void, ForgotPasswordFailure>> forgotPassword(
      String email) async {
    try {
      await CognitoUser(email, _pool).forgotPassword();
      return Union2First(null);
    } on CognitoClientException catch (error) {
      switch (error.code) {
        case "ResourceNotFoundException":
          return Union2Second(
              ForgotPasswordFailure(ForgotPasswordFailureType.invalidUserPool));
        case "InvalidParameterException":
          return Union2Second(
              ForgotPasswordFailure(ForgotPasswordFailureType.invalidEmail));
        case "UserNotFoundException":
          return Union2Second(
              ForgotPasswordFailure(ForgotPasswordFailureType.noSuchUser));
        default:
          return Union2Second(
              ForgotPasswordFailure(ForgotPasswordFailureType.unknown));
      }
    } on ArgumentError catch (_) {
      return Union2Second(
          ForgotPasswordFailure(ForgotPasswordFailureType.invalidUserPool));
    } catch (_) {
      return Union2Second(
          ForgotPasswordFailure(ForgotPasswordFailureType.unknown));
    }
  }

  @override
  Future<Union2<void, SubmitForgotPasswordFailure>> submitForgotPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      await CognitoUser(email, _pool).confirmPassword(code, newPassword);
      return Union2First(null);
    } on CognitoClientException catch (error) {
      switch (error.code) {
        case "ResourceNotFoundException":
          return Union2Second(SubmitForgotPasswordFailure(
              SubmitForgotPasswordFailureType.invalidUserPool));
        case "InvalidParameterException":
          return Union2Second(SubmitForgotPasswordFailure(
              SubmitForgotPasswordFailureType.invalidCodeOrPassword));
        case "CodeMismatchException":
          return Union2Second(SubmitForgotPasswordFailure(
              SubmitForgotPasswordFailureType.invalidCode));
        case "ExpiredCodeException":
          return Union2Second(SubmitForgotPasswordFailure(
              SubmitForgotPasswordFailureType.expiredCode));
        case "UserNotFoundException":
          return Union2Second(SubmitForgotPasswordFailure(
              SubmitForgotPasswordFailureType.noSuchUser));
        default:
          return Union2Second(SubmitForgotPasswordFailure(
              SubmitForgotPasswordFailureType.unknown));
      }
    } catch (_) {
      return Union2Second(
          SubmitForgotPasswordFailure(SubmitForgotPasswordFailureType.unknown));
    }
  }

  @override
  Future<Union2<void, RefreshSessionFailure>> refreshSession() async {
    if (_state.user == null) {
      return Union2Second(
          RefreshSessionFailure(RefreshSessionFailureType.noSuchUser));
    }
    try {
      _state.session =
          await _state.user!.refreshSession(_state.session!.refreshToken!);
      if (_state.session != null) {
        await _state.user!.cacheTokens();
        return Union2First(null);
      } else {
        return Union2Second(
            RefreshSessionFailure(RefreshSessionFailureType.unknown));
      }
    } on CognitoClientException catch (error) {
      switch (error.code) {
        case "ResourceNotFoundException":
          return Union2Second(
              RefreshSessionFailure(RefreshSessionFailureType.invalidUserPool));
        case "NotAuthorizedException":
          return Union2Second(
              RefreshSessionFailure(RefreshSessionFailureType.invalidToken));
        case "UserNotFoundException":
          return Union2Second(
              RefreshSessionFailure(RefreshSessionFailureType.noSuchUser));
        default:
          return Union2Second(
              RefreshSessionFailure(RefreshSessionFailureType.unknown));
      }
    } on ArgumentError catch (_) {
      return Union2Second(
          RefreshSessionFailure(RefreshSessionFailureType.invalidUserPool));
    } catch (_) {
      return Union2Second(
          RefreshSessionFailure(RefreshSessionFailureType.unknown));
    }
  }
}

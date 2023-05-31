import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../errors.dart';
import '../http/http.dart';
import 'responses/responses.dart';

export 'responses/responses.dart';

part 'bloc/bloc.dart';
part 'bloc/event.dart';
part 'bloc/state.dart';

class _CognitoState {
  CognitoUser? user;
  CognitoUserSession? session;
}

const kAdminPoolIdJsonKey = 'adminPoolId';
const kUserPoolIdJsonKey = 'userPoolId';
const kAdminClientIdJsonKey = 'adminClientId';
const kUserClientIdJsonKey = 'userClientId';

class Cognito {
  final CognitoUserPool _pool;
  final _CognitoState _state;

  factory Cognito.fromJson(dynamic json, bool admin) => switch (json) {
        {
          kAdminPoolIdJsonKey: final String adminPoolId,
          kAdminClientIdJsonKey: final String adminClientId,
          kUserPoolIdJsonKey: final String userPoolId,
          kUserClientIdJsonKey: final String userClientId
        } =>
          Cognito(
            poolId: admin ? adminPoolId : userPoolId,
            clientId: admin ? adminClientId : userClientId,
          ),
        _ => throw FormatException('Invalid JSON for Cognito', json),
      };

  Cognito({
    required String poolId,
    required String clientId,
  })  : _pool = CognitoUserPool(poolId, clientId),
        _state = _CognitoState(),
        super();

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
        _ => LoginCognitoFailure(message: error.message),
      };
    } on ArgumentError catch (_) {
      return const LoginFailure(LoginFailureType.invalidUserPool);
    } on CognitoUserNewPasswordRequiredException {
      return const LoginFailure(LoginFailureType.changePasswordRequired);
    } catch (err) {
      return const LoginFailure(LoginFailureType.unknown);
    }
  }

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
        _state.user = signUpResult.user;
        return const RegisterSuccess();
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

  Future<bool> confirmEmail(
    String email,
    String code,
  ) =>
      _state.user?.confirmRegistration(code).catchError((_) => false) ??
      Future.value(false);

  Future<bool> resendConfirmationEmail(
    String email,
  ) async {
    if (_state.user != null) {
      try {
        await _state.user!.resendConfirmationCode();
        return true;
      } catch (_) {}
    }
    return false;
  }

  Future<ForgotPasswordFailure?> forgotPassword(
    String email,
  ) async {
    try {
      _state.user = CognitoUser(email, _pool);
      await _state.user!.forgotPassword();
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

  Future<SubmitForgotPasswordFailure?> submitForgotPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      if (_state.user != null) {
        if (await _state.user!.confirmPassword(code, newPassword)) {
          return null;
        } else {
          return SubmitForgotPasswordFailure.invalidCode;
        }
      } else {
        return SubmitForgotPasswordFailure.noSuchUser;
      }
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

  Future<ChangePasswordFailure?> changePassword({
    required String newPassword,
  }) async {
    try {
      if (_state.user != null) {
        _state.session = await _state.user!.sendNewPasswordRequiredAnswer(
          newPassword,
        );
      } else {
        return const ChangePasswordTypedFailure(
            ChangePasswordFailureType.noSuchUser);
      }
      return null;
    } on CognitoClientException catch (error) {
      return switch (error.code) {
        'ResourceNotFoundException' => const ChangePasswordTypedFailure(
            ChangePasswordFailureType.invalidUserPool),
        'NotAuthorizedException' => const ChangePasswordTypedFailure(
            ChangePasswordFailureType.invalidPassword),
        'UserNotFoundException' => const ChangePasswordTypedFailure(
            ChangePasswordFailureType.noSuchUser),
        _ => ChangePasswordCognitoFailure(message: error.message),
      };
    } on ArgumentError catch (_) {
      return const ChangePasswordTypedFailure(
          ChangePasswordFailureType.invalidUserPool);
    } catch (err) {
      return const ChangePasswordTypedFailure(
          ChangePasswordFailureType.unknown);
    }
  }
}

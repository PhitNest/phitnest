import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core.dart';

part 'bloc/bloc.dart';
part 'bloc/event.dart';
part 'bloc/state.dart';

part 'event_handlers/previous_session.dart';
part 'event_handlers/pools.dart';
part 'event_handlers/login.dart';
part 'event_handlers/login_response.dart';
part 'event_handlers/cancel_request.dart';
part 'event_handlers/change_password.dart';
part 'event_handlers/change_password_response.dart';

part 'responses/change_password.dart';
part 'responses/constants.dart';
part 'responses/forgot_password.dart';
part 'responses/login.dart';
part 'responses/refresh_session.dart';
part 'responses/register.dart';
part 'responses/submit_forgot_password.dart';

part 'secure_storage.dart';
part 'session.dart';
part 'pools.dart';

// Future<RegisterResponse> _register({
//   required String email,
//   required String password,
//   required List<AttributeArg> userAttributes,
//   required CognitoUserPool pool,
// }) async {
//   try {
//     final signUpResult = await pool.signUp(
//       email,
//       password,
//       userAttributes: [
//         AttributeArg(name: 'email', value: email),
//         ...userAttributes,
//       ],
//     );
//     if (signUpResult.userSub != null) {
//       return RegisterSuccess(signUpResult.user);
//     } else {
//       return const RegisterUnknownResponse();
//     }
//   } on CognitoClientException catch (error) {
//     return switch (error.code) {
//       'ResourceNotFoundException' =>
//         const RegisterFailure((RegisterFailureType.invalidUserPool)),
//       'UsernameExistsException' =>
//         const RegisterFailure(RegisterFailureType.userExists),
//       'InvalidPasswordException' =>
//         ValidationFailure(ValidationFailureType.invalidPassword, 
//          error.message,
//         ),
//       'InvalidParameterException' =>
//         ValidationFailure(ValidationFailureType.invalidEmail, error.message),
//       _ => RegisterUnknownResponse(message: error.message),
//     };
//   } on ArgumentError catch (_) {
//     return const RegisterFailure(RegisterFailureType.invalidUserPool);
//   } catch (err) {
//     return RegisterUnknownResponse(message: err.toString());
//   }
// }

// Future<bool> confirmEmail(
//   String email,
//   String code,
// ) =>
//     _state.user?.confirmRegistration(code).catchError((_) => false) ??
//     Future.value(false);

// Future<bool> resendConfirmationEmail(
//   String email,
// ) async {
//   if (_state.user != null) {
//     try {
//       await _state.user!.resendConfirmationCode();
//       return true;
//     } catch (_) {}
//   }
//   return false;
// }

// Future<ForgotPasswordFailure?> forgotPassword(
//   String email,
// ) async {
//   try {
//     _state.user = CognitoUser(email, _pool);
//     await _state.user!.forgotPassword();
//     return null;
//   } on CognitoClientException catch (error) {
//     return switch (error.code) {
//       'ResourceNotFoundException' => ForgotPasswordFailure.invalidUserPool,
//       'InvalidParameterException' => ForgotPasswordFailure.invalidEmail,
//       'UserNotFoundException' => ForgotPasswordFailure.noSuchUser,
//       _ => ForgotPasswordFailure.unknown,
//     };
//   } on ArgumentError catch (_) {
//     return ForgotPasswordFailure.invalidUserPool;
//   } catch (_) {
//     return ForgotPasswordFailure.unknown;
//   }
// }

// Future<SubmitForgotPasswordFailure?> submitForgotPassword(
//   String email,
//   String code,
//   String newPassword,
// ) async {
//   try {
//     if (_state.user != null) {
//       if (await _state.user!.confirmPassword(code, newPassword)) {
//         return null;
//       } else {
//         return SubmitForgotPasswordFailure.invalidCode;
//       }
//     } else {
//       return SubmitForgotPasswordFailure.noSuchUser;
//     }
//   } on CognitoClientException catch (error) {
//     return switch (error.code) {
//       'ResourceNotFoundException' =>
//         SubmitForgotPasswordFailure.invalidUserPool,
//       'InvalidParameterException' =>
//         SubmitForgotPasswordFailure.invalidCodeOrPassword,
//       'CodeMismatchException' => SubmitForgotPasswordFailure.invalidCode,
//       'ExpiredCodeException' => SubmitForgotPasswordFailure.expiredCode,
//       'UserNotFoundException' => SubmitForgotPasswordFailure.noSuchUser,
//       _ => SubmitForgotPasswordFailure.unknown,
//     };
//   } catch (_) {
//     return SubmitForgotPasswordFailure.unknown;
//   }
// }

// Future<RefreshSessionFailure?> refreshSession({
//   bool admin = false,
// }) async {
//   if (_state.user == null) {
//     return RefreshSessionFailure.noSuchUser;
//   }
//   try {
//     _state.session =
//         await _state.user!.refreshSession(_state.session!.refreshToken!);
//     if (_state.session != null) {
//       await _state.user!.cacheTokens();
//       return null;
//     } else {
//       return RefreshSessionFailure.unknown;
//     }
//   } on CognitoClientException catch (error) {
//     return switch (error.code) {
//       'ResourceNotFoundException' => RefreshSessionFailure.invalidUserPool,
//       'NotAuthorizedException' => RefreshSessionFailure.invalidToken,
//       'UserNotFoundException' => RefreshSessionFailure.noSuchUser,
//       _ => RefreshSessionFailure.unknown,
//     };
//   } on ArgumentError catch (_) {
//     return RefreshSessionFailure.invalidUserPool;
//   } catch (_) {
//     return RefreshSessionFailure.unknown;
//   }
// }

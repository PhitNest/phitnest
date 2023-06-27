import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../core.dart';

part 'bloc/bloc.dart';
part 'bloc/event.dart';
part 'bloc/state.dart';
part 'event_handlers/cancel_request.dart';
part 'event_handlers/change_password.dart';
part 'event_handlers/change_password_response.dart';
part 'event_handlers/confirm_email.dart';
part 'event_handlers/confirm_email_failed.dart';
part 'event_handlers/login.dart';
part 'event_handlers/login_response.dart';
part 'event_handlers/logout.dart';
part 'event_handlers/logout_response.dart';
part 'event_handlers/pools.dart';
part 'event_handlers/previous_session.dart';
part 'event_handlers/register.dart';
part 'event_handlers/register_response.dart';
part 'event_handlers/resend_confirm_email.dart';
part 'event_handlers/resend_confirm_email_response.dart';
part 'pools.dart';
part 'responses/change_password.dart';
part 'responses/constants.dart';
part 'responses/forgot_password.dart';
part 'responses/login.dart';
part 'responses/refresh_session.dart';
part 'responses/register.dart';
part 'responses/submit_forgot_password.dart';
part 's3.dart';
part 'secure_storage.dart';
part 'session.dart';





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

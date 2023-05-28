import 'dart:math';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core.dart';
import 'responses/responses.dart';

part 'bloc/bloc.dart';
part 'bloc/event.dart';
part 'bloc/state.dart';
part 'cognito/cognito.dart';
part 'sandbox/sandbox.dart';
part 'sandbox/user_data.dart';

const kAdminPoolIdJsonKey = 'adminPoolId';
const kUserPoolIdJsonKey = 'userPoolId';
const kAdminClientIdJsonKey = 'adminClientId';
const kUserClientIdJsonKey = 'userClientId';

sealed class Auth extends JsonSerializable {
  const Auth() : super();

  factory Auth.fromJson(
    dynamic serverStatus,
    bool admin,
  ) =>
      switch (serverStatus) {
        'sandbox' => Sandbox.getFromCache() ??
            Sandbox(
              emailToUserMap: {},
              idToUserMap: {},
              currentUser: null,
            ),
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
        _ => throw FormatException('Invalid server status: $serverStatus'),
      };

  Future<LoginResponse> login(
    String email,
    String password,
  );

  Future<RegisterResponse> register(
    String email,
    String password,
    List<AttributeArg> userAttributes,
  );

  Future<bool> confirmEmail(String email, String code);

  Future<bool> resendConfirmationEmail(String email);

  Future<ForgotPasswordFailure?> forgotPassword(String email);

  Future<SubmitForgotPasswordFailure?> submitForgotPassword(
    String email,
    String code,
    String newPassword,
  );

  Future<RefreshSessionFailure?> refreshSession();

  Future<ChangePasswordFailure?> changePassword({
    required String email,
    required String newPassword,
  });
}

import 'dart:math';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../failure.dart';
import '../http/http.dart';
import 'responses/responses.dart';
import '../../cache.dart';
import '../../serializable.dart';
import '../../validators/validators.dart';

part 'cognito/cognito.dart';
part 'sandbox/sandbox.dart';
part 'sandbox/user_data.dart';
part 'status.dart';

const kAdminPoolIdJsonKey = "adminPoolId";
const kUserPoolIdJsonKey = "userPoolId";
const kAdminClientIdJsonKey = "adminClientId";
const kUserClientIdJsonKey = "userClientId";

class CognitoPoolDetails extends Equatable {
  final String userPoolId;
  final String clientId;

  const CognitoPoolDetails({
    required this.userPoolId,
    required this.clientId,
  });

  @override
  List<Object?> get props => [userPoolId, clientId];
}

sealed class Auth extends JsonSerializable {
  const Auth() : super();

  factory Auth.fromJson(dynamic serverStatus, bool admin) =>
      switch (serverStatus) {
        "sandbox" => Sandbox.getFromCache() ??
            Sandbox(
              emailToUserMap: {},
              idToUserMap: {},
              currentUser: null,
            ),
        {
          kAdminPoolIdJsonKey: String adminPoolId,
          kAdminClientIdJsonKey: String adminClientId,
          kUserPoolIdJsonKey: String userPoolId,
          kUserClientIdJsonKey: String userClientId
        } =>
          Cognito(CognitoPoolDetails(
            userPoolId: admin ? adminPoolId : userPoolId,
            clientId: admin ? adminClientId : userClientId,
          )),
        _ => throw FormatException("Invalid server status: $serverStatus"),
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
}

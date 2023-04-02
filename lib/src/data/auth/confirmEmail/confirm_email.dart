import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../auth.dart';

export './response/response.dart';

Future<ConfirmEmailResponse> confirmEmail({
  required String email,
  required String code,
  required ServerStatus serverStatus,
}) =>
    serverStatus.when(
        live: (userPoolId, clientId) async {
          try {
            return await CognitoUser(
              email,
              CognitoUserPool(
                userPoolId,
                clientId,
              ),
            )
                .confirmRegistration(
                  code,
                )
                .then(
                  (successful) => successful
                      ? const ConfirmEmailResponse.success()
                      : const ConfirmEmailResponse.incorrectCode(),
                );
          } on ArgumentError catch (_) {
            return const ConfirmEmailResponse.invalidCognitoPool();
          }
        },
        sandbox: () => Future.value(const ConfirmEmailResponse.sandbox()));

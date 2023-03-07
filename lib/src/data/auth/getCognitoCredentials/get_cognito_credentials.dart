import 'package:phitnest_utils/utils.dart';

import '../../../entities/entities.dart';
import 'failure.dart';

Future<
    Either4<
        CognitoCredentialsEntity,
        GetCognitoCredentialsFailure,
        InvalidResponseFailure,
        NetworkConnectionFailure>> getCognitoCredentials() => requestJson(
      route: '/auth/cognitoCredentials',
      method: HttpMethod.get,
      successParser: (json) {
        final credentials = CognitoCredentialsEntity.fromJson(json);
        if (credentials.userPoolId == "sandbox" ||
            credentials.clientId == "sandbox") {
          throw const GetCognitoCredentialsFailure.sandbox();
        }
        return credentials;
      },
      failureParser: (json) => const GetCognitoCredentialsFailure.unknown(),
      data: {},
    );

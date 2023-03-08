import 'package:dartz/dartz.dart';
import 'package:phitnest_utils/utils.dart';

import '../../entities/entities.dart';

Future<Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
    getCognitoCredentials() => request(
          route: '/auth/cognitoCredentials',
          method: HttpMethod.get,
          parser: (response) {
            final credentials =
                CognitoCredentialsEntity.fromJson(response.data);
            if (credentials.clientId == "sandbox" ||
                credentials.clientId == "sandbox") {
              return const CognitoCredentialsEntity.sandbox();
            } else {
              return credentials;
            }
          },
          data: {},
        );

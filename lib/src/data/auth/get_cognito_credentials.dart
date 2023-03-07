import 'package:phitnest_utils/utils.dart';

import '../../common/unknown_failure.dart';
import '../../domain/entities/entities.dart';

Future<
    Either3<CognitoCredentialsEntity, UnknownFailure,
        NetworkConnectionFailure>> getCognitoCredentials() => requestJson(
      route: '/auth/cognitoCredentials',
      method: HttpMethod.get,
      successParser: CognitoCredentialsEntity.fromJson,
      failureParser: (json) => const UnknownFailure(),
      data: {},
    );

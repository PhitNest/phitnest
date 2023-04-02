import 'package:dartz/dartz.dart';
import 'package:phitnest_utils/utils.dart';

import '../auth.dart';

export 'response/response.dart';

Future<Either<ServerStatus, NetworkConnectionFailure>> getServerStatus() =>
    request(
      route: '/auth/serverStatus',
      method: HttpMethod.get,
      parser: (response) {
        // Handle local development
        if (response.data == "sandbox") {
          return const ServerStatus.sandbox();
        } else {
          // Connect to Cognito auth server
          return ServerStatus.live(
            userPoolId: response.data.userPoolId,
            clientId: response.data.clientId,
          );
        }
      },
    );

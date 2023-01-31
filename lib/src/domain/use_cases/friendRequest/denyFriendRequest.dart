import '../../../common/failure.dart';
import '../../../data/adapters/adapters.dart';
import '../../../data/data_sources/backend/backend.dart';

Future<Failure?> denyFriendRequest(
  String senderCognitoId,
) =>
    httpAdapter
        .request(
          kDenyFriendRequestRoute,
          DenyFriendRequest(
            senderCognitoId: senderCognitoId,
          ),
        )
        .then(
          (res) => res.fold(
            (_) => null,
            (failure) => failure,
          ),
        );

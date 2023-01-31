import '../../../common/failure.dart';
import '../../../data/adapters/adapters.dart';
import '../../../data/data_sources/backend/backend.dart';

Future<Failure?> denyFriendRequest(
  String senderCognitoId,
) =>
    httpAdapter.requestVoid(
      kDenyFriendRequestRoute,
      DenyFriendRequest(
        senderCognitoId: senderCognitoId,
      ),
    );

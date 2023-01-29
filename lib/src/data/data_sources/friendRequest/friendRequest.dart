import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../domain/entities/friend_request.entity.dart';
import '../../../domain/entities/friendship.entity.dart';
import '../../adapters/adapters.dart';
import 'requests/requests.dart';

abstract class FriendRequestDataSource {
  static FEither3<FriendRequestEntity, FriendshipEntity, Failure>
      sendFriendRequest(
    String recipientCognitoId,
  ) =>
          httpAdapter.requestEither(
            Routes.sendFriendRequest.instance,
            data: SendFriendRequestRequest(
              recipientCognitoId: recipientCognitoId,
            ),
          );

  static Future<Failure?> denyFriendRequest(
    String senderCognitoId,
  ) =>
      httpAdapter.request(
        Routes.denyFriendRequest.instance,
        data: DenyFriendRequestRequest(senderCognitoId: senderCognitoId),
      );
}

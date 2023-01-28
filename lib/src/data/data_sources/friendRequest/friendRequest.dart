import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../domain/entities/friendRequest.entity.dart';
import '../../../domain/entities/friendship.entity.dart';
import '../../adapters/adapters.dart';

abstract class FriendRequestDataSource {
  static FEither3<FriendRequestEntity, FriendshipEntity, Failure>
      sendFriendRequest(
    String recipientCognitoId,
  ) =>
          httpAdapter.request(
            Routes.sendFriendRequest.instance,
            data: {'recipientCognitoId': recipientCognitoId},
          ).then(
            (either) => either.fold(
              (json) {
                try {
                  return First(FriendRequestEntity.fromJson(json));
                } catch (_) {
                  return Second(FriendshipEntity.fromJson(json));
                }
              },
              (list) => Third(Failures.invalidBackendResponse.instance),
              (failure) => Third(failure),
            ),
          );

  static Future<Failure?> denyFriendRequest(
    String senderCognitoId,
  ) =>
      httpAdapter.request(
        Routes.denyFriendRequest.instance,
        data: {'senderCognitoId': senderCognitoId},
      ).then(
        (response) => response.fold(
          (json) => null,
          (list) => Failures.invalidBackendResponse.instance,
          (failure) => failure,
        ),
      );
}

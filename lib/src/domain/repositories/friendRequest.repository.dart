import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/adapters/adapters.dart';
import '../../data/data_sources/backend/backend.dart';
import '../entities/entities.dart';

abstract class FriendRequestRepository {
  static FEither<Either<FriendRequestEntity, FriendshipEntity>, Failure>
      getFriendRequest(
    String recipientCognitoId,
  ) async {
    final result = httpAdapter.request(
      kSendFriendRequestRoute,
      SendFriendRequest(
        recipientCognitoId: recipientCognitoId,
      ),
    );

    return result;
  }

  static Future<Failure?> denyFriendRequest(
    String senderCognitoId,
  ) async {
    final result = await httpAdapter.request(
      kDenyFriendRequestRoute,
      DenyFriendRequest(
        senderCognitoId: senderCognitoId,
      ),
    );

    return result.fold(
      (response) => null,
      (failure) => failure,
    );
  }
}

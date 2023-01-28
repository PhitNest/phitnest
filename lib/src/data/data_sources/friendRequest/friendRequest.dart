import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../domain/entities/friendRequest.entity.dart';
import '../../../domain/entities/friendship.entity.dart';
import '../../adapters/adapters.dart';

abstract class FriendRequestDataSource {
  static Future<Either<Object, Failure>> sendFriendRequest(
    String recipientCognitoId,
  ) =>
      httpAdapter.request(
        Routes.sendFriendRequest.instance,
        data: {'recipientCognitoId': recipientCognitoId},
      ).then(
        (either) => either.fold(
          (response) => response.fold(
            (json) {
              try {
                return Left(FriendRequestEntity.fromJson(json));
              } catch (_) {
                return Left(FriendshipEntity.fromJson(json));
              }
            },
            (list) => Right(Failures.invalidBackendResponse.instance),
          ),
          (failure) => Right(failure),
        ),
      );

  static Future<Failure?> denyFriendRequest(
    String senderCognitoId,
  ) =>
      httpAdapter.request(
        Routes.denyFriendRequest.instance,
        data: {'senderCognitoId': senderCognitoId},
      ).then(
        (either) => either.fold(
          (response) => response.fold(
            (json) => null,
            (list) => Failures.invalidBackendResponse.instance,
          ),
          (failure) => failure,
        ),
      );
}

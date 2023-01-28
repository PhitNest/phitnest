import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';
import 'response/friendsAndMessage.dart';
import 'response/friendsAndRequests.dart';

abstract class FriendshipDataSource {
  static FEither<List<FriendsAndMessagesResponse>, Failure>
      friendsAndMessages() => httpAdapter
          .request(Routes.friendsAndMessages.instance)
          .then(
            (either) => either.fold(
              (json) {
                try {
                  return Left(
                    List<FriendsAndMessagesResponse>.from(json[''])
                        .map(
                          (res) => FriendsAndMessagesResponse(
                            friendship: PopulatedFriendshipEntity.fromJson(
                                json['friendship']),
                            message:
                                DirectMessageEntity.fromJson(json['message']),
                          ),
                        )
                        .toList(),
                  );
                } catch (_) {
                  return Left(
                    List<FriendsAndMessagesResponse>.from(json[''])
                        .map(
                          (res) => FriendsAndMessagesResponse(
                              friendship: PopulatedFriendshipEntity.fromJson(
                                  json[res.friendship.friend.toString()]),
                              message: null),
                        )
                        .toList(),
                  );
                }
              },
              (list) => Right(Failures.invalidBackendResponse.instance),
              (failure) => Right(failure),
            ),
          );

  static FEither<FriendsAndRequestsResponse, Failure> friendsAndRequests() =>
      httpAdapter
          .request(
            Routes.friendsAndRequests.instance,
          )
          .then(
            (either) => either.fold(
              (json) => Left(FriendsAndRequestsResponse.fromJson(json)),
              (list) => Right(Failures.invalidBackendResponse.instance),
              (failure) => Right(failure),
            ),
          );

  static Future<Failure?> removeFriend(String friendCognitoId) {
    return httpAdapter.request(
      Routes.removeFriend.instance,
      data: {
        'friendCognitoId': friendCognitoId,
      },
    ).then(
      (either) => either.fold(
        (json) => null,
        (list) => Failures.invalidBackendResponse.instance,
        (failure) => failure,
      ),
    );
  }
}

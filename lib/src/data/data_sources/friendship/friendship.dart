import 'package:dartz/dartz.dart';
import 'package:phitnest_mobile/src/data/data_sources/friendship/response/friendsAndRequests.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../adapters/adapters.dart';
import 'response/friendsAndMessage.dart';

abstract class FriendshipDataSource {
  static Future<Either<List<FriendsAndMessagesResponse>, Failure>>
      friendsAndMessages() => httpAdapter
          .request(Routes.friendsAndMessages.instance)
          .then(
            (either) => either.fold(
              (response) => response.fold(
                (json) {
                  try {
                    return Left([FriendsAndMessagesResponse.fromJson(json)]);
                  } catch (_) {
                    return Left([
                      FriendsAndMessagesResponse(
                        friendship: PopulatedFriendshipEntity.fromJson(
                            json['friendship']),
                        message: null,
                      ),
                    ]);
                  }
                },
                (list) => Right(Failures.invalidBackendResponse.instance),
              ),
              (failure) => Right(failure),
            ),
          );

  static Future<Either<FriendsAndRequestsResponse, Failure>>
      friendsAndRequests() => httpAdapter
          .request(
            Routes.friendsAndRequests.instance,
          )
          .then(
            (either) => either.fold(
              (response) => response.fold(
                (json) => Left(FriendsAndRequestsResponse.fromJson(json)),
                (list) => Right(Failures.invalidBackendResponse.instance),
              ),
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
        (response) => response.fold(
          (json) => null,
          (list) => Failures.invalidBackendResponse.instance,
        ),
        (failure) => failure,
      ),
    );
  }
}

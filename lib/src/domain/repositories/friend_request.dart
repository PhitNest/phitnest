part of repository;

class FriendRequest {
  const FriendRequest();

  Future<Either3<FriendRequestEntity, FriendshipEntity, Failure>> send({
    required String accessToken,
    required String recipientCognitoId,
  }) =>
      Backend.friendRequest
          .send(
        accessToken: accessToken,
        recipientCognitoId: recipientCognitoId,
      )
          .then(
        (either) {
          final removeFromExplore = () => Cache.user
              .cacheUserExplore(
                Cache.user.userExploreResponse
                  ?..removeWhere(
                    (user) => user.id == recipientCognitoId,
                  ),
              )
              .then((_) => null);
          return either.fold(
            (request) => removeFromExplore().then((_) => First(request)),
            (friendship) => Future.wait(
              [
                Cache.friendship.cacheFriendsAndRequests(
                  Cache.friendship.friendsAndRequests
                    ?..requests.removeWhere((request) =>
                        request.fromCognitoId == recipientCognitoId)
                    ..friendships.insert(0, friendship),
                ),
                Cache.friendship.cacheFriendsAndMessages(
                  (Cache.friendship.friendsAndMessages ?? [])
                    ..insert(
                      0,
                      FriendsAndMessagesResponse(
                        friendship: friendship,
                        message: null,
                      ),
                    ),
                ),
                removeFromExplore(),
              ],
            ).then((_) => Second(friendship)),
            (failure) => Third(failure),
          );
        },
      );

  Future<Failure?> deny({
    required String accessToken,
    required String senderCognitoId,
  }) =>
      Backend.friendRequest
          .deny(
        accessToken: accessToken,
        senderCognitoId: senderCognitoId,
      )
          .then((failure) {
        if (failure == null) {
          Future.wait(
            [
              Cache.user.cacheUserExplore(
                Cache.user.userExploreResponse
                  ?..removeWhere(
                    (user) => user.id == senderCognitoId,
                  ),
              ),
              Cache.friendship.cacheFriendsAndRequests(
                Cache.friendship.friendsAndRequests
                  ?..requests.removeWhere(
                      (request) => request.fromCognitoId == senderCognitoId),
              ),
            ],
          ).then((_) => null);
        }
        return failure;
      });
}

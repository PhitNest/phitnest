part of repository;

class Friendship {
  const Friendship();

  Future<Either<List<FriendsAndMessagesResponse>, Failure>> friendsAndMessages(
          String accessToken) =>
      Backend.friendship.friendsAndMessages(accessToken).then(
            (either) => either.fold(
              (response) =>
                  Cache.friendship.cacheFriendsAndMessages(response).then(
                        (_) => Left(response),
                      ),
              (failure) => Right(failure),
            ),
          );
}

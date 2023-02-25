part of repository;

class DirectMessage {
  const DirectMessage();

  Future<Either<List<DirectMessageEntity>, Failure>> getDirectMessage({
    required String accessToken,
    required String friendCognitoId,
  }) =>
      Backend.directMessage
          .getDirectMessages(
            accessToken: accessToken,
            friendCognitoId: friendCognitoId,
          )
          .then(
            (either) => either.fold(
              (response) => Cache.directMessage
                  .cacheDirectMessages(response, friendCognitoId)
                  .then(
                    (_) => Left(response),
                  ),
              (failure) => Right(failure),
            ),
          );
}

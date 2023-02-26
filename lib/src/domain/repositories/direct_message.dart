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

  Future<Either<Stream<Future<PopulatedDirectMessageEntity>>, Failure>> stream({
    required SocketConnection connection,
  }) =>
      Backend.directMessage.stream(connection: connection).then(
            (either) => either.fold(
              (stream) => Left(
                stream.map(
                  (directMessage) => Future.wait(
                    [
                      Cache.friendship.cacheFriendsAndMessages(
                        Function.apply(
                          () {
                            final conversations =
                                Cache.friendship.friendsAndMessages ?? [];
                            final conversationIndex = conversations.indexWhere(
                              (element) =>
                                  element.friendship.id ==
                                  directMessage.friendshipId,
                            );
                            FriendsAndMessagesResponse? conversation;
                            if (conversationIndex != -1) {
                              conversation =
                                  conversations.removeAt(conversationIndex);
                              return conversations
                                ..insert(
                                  0,
                                  FriendsAndMessagesResponse(
                                    friendship: conversation.friendship,
                                    message: directMessage,
                                  ),
                                );
                            }
                          },
                          [],
                        ),
                      ),
                      Cache.directMessage.cacheDirectMessages(
                        Cache.directMessage
                            .getDirectMessages(directMessage.senderCognitoId)
                          ?..insert(
                            0,
                            directMessage,
                          ),
                        directMessage.senderCognitoId,
                      ),
                    ],
                  ).then((_) => directMessage),
                ),
              ),
              (failure) => Right(failure),
            ),
          );
}

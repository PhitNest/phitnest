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

  Either<Stream<Future<PopulatedDirectMessageEntity>>, Failure> stream({
    required SocketConnection connection,
  }) =>
      Backend.directMessage.stream(connection: connection).fold(
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
          );

  Future<Either<PopulatedDirectMessageEntity, Failure>> send({
    required SocketConnection connection,
    required String recipientCognitoId,
    required String text,
  }) =>
      Backend.directMessage
          .send(
            connection: connection,
            recipientCognitoId: recipientCognitoId,
            text: text,
          )
          .then((res) => res.fold(
              (message) => Future.wait(
                    [
                      Cache.friendship.cacheFriendsAndMessages(
                        Function.apply(
                          () {
                            final conversations =
                                Cache.friendship.friendsAndMessages ?? [];
                            final conversationIndex = conversations.indexWhere(
                              (element) =>
                                  element.friendship.id == message.friendshipId,
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
                                    message: message,
                                  ),
                                );
                            }
                          },
                          [],
                        ),
                      ),
                      Cache.directMessage.cacheDirectMessages(
                        Cache.directMessage.getDirectMessages(
                                message.recipient.cognitoId) ??
                            []
                          ..insert(0, message),
                        message.recipient.cognitoId,
                      ),
                    ],
                  ).then((_) => Left(message)),
              (failure) => Right(failure)));
}

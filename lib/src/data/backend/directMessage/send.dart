part of backend;

extension SendDirectMessage on DirectMessage {
  Future<Either<PopulatedDirectMessageEntity, Failure>> send({
    required SocketConnection connection,
    required String recipientCognitoId,
    required String text,
  }) =>
      connection.emit(
        event: SocketEvent.directMessage,
        data: {
          "recipientCognitoId": recipientCognitoId,
          "text": text,
        },
        parser: PopulatedDirectMessageEntity.fromJson,
      );
}

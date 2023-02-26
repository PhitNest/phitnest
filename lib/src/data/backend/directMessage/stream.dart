part of backend;

extension StreamDirectMessages on DirectMessage {
  Either<Stream<PopulatedDirectMessageEntity>, Failure> stream({
    required SocketConnection connection,
  }) =>
      connection.stream(
        SocketEvent.directMessage,
        PopulatedDirectMessageEntity.fromJson,
      );
}

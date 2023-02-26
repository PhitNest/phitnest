part of backend;

extension StreamFriendships on Friendship {
  Either<Stream<PopulatedFriendshipEntity>, Failure> stream({
    required SocketConnection connection,
  }) =>
      connection.stream(
        SocketEvent.friendship,
        PopulatedFriendshipEntity.fromJson,
      );
}

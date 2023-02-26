part of backend;

extension StreamFriendships on Friendship {
  Future<Either<Stream<PopulatedFriendshipEntity>, Failure>> stream({
    required SocketConnection connection,
  }) =>
      connection.stream(
        SocketEvent.friendship,
        PopulatedFriendshipEntity.fromJson,
      );
}

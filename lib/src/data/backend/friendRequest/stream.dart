part of backend;

extension StreamFriendRequests on FriendRequest {
  Future<Either<Stream<PopulatedFriendRequestEntity>, Failure>> stream({
    required SocketConnection connection,
  }) =>
      connection.stream(
        SocketEvent.friendRequest,
        PopulatedFriendRequestEntity.fromJson,
      );
}

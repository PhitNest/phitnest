part of backend;

extension StreamFriendRequests on FriendRequest {
  Either<Stream<PopulatedFriendRequestEntity>, Failure> stream({
    required SocketConnection connection,
  }) =>
      connection.stream(
        SocketEvent.friendRequest,
        PopulatedFriendRequestEntity.fromJson,
      );
}

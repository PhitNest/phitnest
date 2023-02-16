part of backend;

extension Send on FriendRequest {
  Future<Either3<FriendRequestEntity, FriendshipEntity, Failure>> send({
    required String accessToken,
    required String recipientCognitoId,
  }) =>
      _requestEither(
        route: "/friendRequest",
        method: HttpMethod.post,
        parserLeft: FriendRequestEntity.fromJson,
        parserRight: FriendshipEntity.fromJson,
        authorization: accessToken,
        data: {
          'recipientCognitoId': recipientCognitoId,
        },
      );
}

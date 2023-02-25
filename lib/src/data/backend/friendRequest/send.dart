part of backend;

extension Send on FriendRequest {
  Future<
      Either3<PopulatedFriendRequestEntity, PopulatedFriendshipEntity,
          Failure>> send({
    required String accessToken,
    required String recipientCognitoId,
  }) =>
      _requestEither(
        route: "/friendRequest",
        method: HttpMethod.post,
        parserLeft: PopulatedFriendRequestEntity.fromJson,
        parserRight: PopulatedFriendshipEntity.fromJson,
        authorization: accessToken,
        data: {
          'recipientCognitoId': recipientCognitoId,
        },
      );
}

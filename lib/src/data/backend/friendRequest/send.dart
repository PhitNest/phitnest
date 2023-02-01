part of backend;

Future<Either3<FriendRequestEntity, FriendshipEntity, Failure>> _send({
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

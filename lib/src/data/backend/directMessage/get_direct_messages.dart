part of backend;

Future<Either<List<DirectMessageEntity>, Failure>> _getDirectMessages({
  required String accessToken,
  required String friendCognitoId,
}) =>
    _requestList(
      route: "/directMessage/list",
      method: HttpMethod.get,
      parser: DirectMessageEntity.fromJson,
      authorization: accessToken,
      data: {
        'friendCognitoId': friendCognitoId,
      },
    );

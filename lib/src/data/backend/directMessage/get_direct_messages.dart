part of backend;

extension GetDirectMessages on DirectMessage {
  Future<Either<List<DirectMessageEntity>, Failure>> getDirectMessages({
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
}

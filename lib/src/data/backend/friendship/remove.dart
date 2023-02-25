part of backend;

extension RemoveFriend on Friendship {
  Future<Failure?> remove({
    required String accessToken,
    required String friendCognitoId,
  }) =>
      _request(
        route: '/friendship',
        method: HttpMethod.delete,
        authorization: accessToken,
        data: {
          'friendCognitoId': friendCognitoId,
        },
      );
}

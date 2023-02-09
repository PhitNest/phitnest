part of backend;

extension Deny on _FriendRequest {
  Future<Failure?> deny({
    required String accessToken,
    required String senderCognitoId,
  }) =>
      _request(
        route: "/friendRequest/deny",
        method: HttpMethod.post,
        authorization: accessToken,
        data: {
          'senderCognitoId': senderCognitoId,
        },
      );
}

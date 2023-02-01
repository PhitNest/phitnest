part of backend;

Future<Failure?> _deny({
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

part of backend;

Future<Failure?> _signOut({
  required String accessToken,
  required bool allDevices,
}) =>
    _request(
      route: "/auth/signOut",
      method: HttpMethod.post,
      data: {
        'allDevices': allDevices,
      },
      authorization: accessToken,
    );

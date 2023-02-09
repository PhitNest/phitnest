part of backend;

extension SignOut on _Auth {
  Future<Failure?> signOut({
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
}

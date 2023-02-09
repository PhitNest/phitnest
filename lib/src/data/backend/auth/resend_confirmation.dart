part of backend;

extension ResendConfirmation on _Auth {
  Future<Failure?> resendConfirmation(String email) => _request(
        route: "/auth/resendConfirmation",
        method: HttpMethod.post,
        data: {
          'email': email,
        },
      );
}

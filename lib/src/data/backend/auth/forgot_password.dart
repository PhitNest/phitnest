part of backend;

extension ForgotPassword on _Auth {
  Future<Failure?> forgotPassword(String email) => _request(
        route: '/auth/forgotPassword',
        method: HttpMethod.post,
        data: {
          'email': email,
        },
      );
}

part of backend;

extension ForgotPasswordSubmit on _Auth {
  Future<Failure?> forgotPasswordSubmit({
    required String email,
    required String code,
    required String newPassword,
  }) =>
      _request(
        route: '/auth/forgotPasswordSubmit',
        method: HttpMethod.post,
        data: {
          'email': email,
          'code': code,
          'newPassword': newPassword,
        },
      );
}

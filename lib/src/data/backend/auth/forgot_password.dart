part of backend;

Future<Failure?> _forgotPassword({
  required String email,
}) =>
    _request(
      route: '/auth/forgotPasswordSubmit',
      method: HttpMethod.post,
      data: {
        'email': email,
      },
    );

part of backend;

Future<Failure?> _forgotPassword({
  required String email,
}) =>
    _request(
      route: '/auth/forgotPassword',
      method: HttpMethod.post,
      data: {
        'email': email,
      },
    );

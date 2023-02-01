part of backend;

Future<Failure?> _resendConfirmation({
  required String email,
}) =>
    _request(
      route: "/auth/resendConfirmation",
      method: HttpMethod.post,
      data: {
        'email': email,
      },
    );

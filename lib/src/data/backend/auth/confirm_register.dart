part of backend;

Future<Either<ProfilePictureUserEntity, Failure>> _confirmRegister({
  required String email,
  required String code,
}) =>
    _requestJson(
      route: "/auth/confirmRegister",
      method: HttpMethod.post,
      parser: ProfilePictureUserEntity.fromJson,
      data: {
        'email': email,
        'code': code,
      },
    );

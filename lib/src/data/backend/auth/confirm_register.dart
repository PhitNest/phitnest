part of backend;

extension ConfirmRegister on _Auth {
  Future<Either<ProfilePictureUserEntity, Failure>> confirmRegister({
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
}

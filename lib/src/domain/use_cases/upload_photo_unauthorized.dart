part of use_cases;

Future<Failure?> _uploadPhotoUnauthorized({
  required String email,
  required String password,
  required XFile photo,
}) =>
    Backend.profilePictures
        .getUnauthorizedUploadUrl(
          email: email,
          password: password,
        )
        .then(
          (res) => res.fold(
            (res) => uploadPhoto(res.url, photo),
            (failure) => failure,
          ),
        );

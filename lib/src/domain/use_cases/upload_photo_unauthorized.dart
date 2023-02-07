part of use_cases;

Future<Failure?> _uploadPhotoUnauthorized({
  required String email,
  required XFile photo,
}) =>
    Backend.profilePictures
        .getUnauthorizedUploadUrl(
          email: email,
        )
        .then(
          (res) => res.fold(
            (res) => uploadPhoto(res.url, photo),
            (failure) => failure,
          ),
        );

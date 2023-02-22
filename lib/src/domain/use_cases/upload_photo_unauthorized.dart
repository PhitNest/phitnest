part of use_cases;

Future<Failure?> _uploadPhotoUnauthorized({
  required String email,
  required XFile photo,
}) =>
    Backend.profilePicture.getUnauthorizedUploadUrl(email).then(
          (res) => res.fold(
            (res) => uploadPhotoToS3(res.url, photo),
            (failure) => failure,
          ),
        );

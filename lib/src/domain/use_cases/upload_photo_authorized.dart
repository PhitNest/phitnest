part of use_cases;

Future<Failure?> _uploadPhotoAuthorized({
  required String accessToken,
  required XFile photo,
}) =>
    Backend.profilePicture.getUploadUrl(accessToken).then(
          (res) => res.fold(
            (res) => uploadPhotoToS3(res.url, photo),
            (failure) => failure,
          ),
        );

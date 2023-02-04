part of use_cases;

Future<Failure?> _uploadPhotoAuthorized({
  required String accessToken,
  required XFile photo,
}) =>
    Backend.profilePictures.getUploadUrl(accessToken: accessToken).then(
          (res) => res.fold(
            (res) => uploadPhoto(res.url, photo),
            (failure) => failure,
          ),
        );

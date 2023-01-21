import 'package:camera/camera.dart';

import '../../common/failure.dart';
import '../../data/data_sources/backend/backend.dart';
import '../../data/data_sources/s3/s3.dart';

Future<Failure?> uploadPhotoUnauthorized(
  String email,
  String cognitoId,
  XFile photo,
) =>
    profilePictureBackend.getUploadUrlUnauthorized(email, cognitoId).then(
          (res) => res.fold(
            (url) => photoDatabase.uploadPhoto(url, photo),
            (failure) => Future.value(failure),
          ),
        );

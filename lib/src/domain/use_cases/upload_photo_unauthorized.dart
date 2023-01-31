import 'package:camera/camera.dart';

import '../../common/failure.dart';
import '../../data/adapters/adapters.dart';
import '../../data/data_sources/backend/backend.dart';
import '../../data/data_sources/s3/s3.dart';

Future<Failure?> uploadPhotoUnauthorized(
  String email,
  String password,
  XFile photo,
) =>
    httpAdapter
        .request(
          kGetUploadUrlUnauthorized,
          GetUploadUrlUnauthorizedRequest(
            email: email,
            password: password,
          ),
        )
        .then(
          (res) => res.fold(
            (res) => uploadPhoto(res.url, photo),
            (failure) => failure,
          ),
        );

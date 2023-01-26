import 'package:camera/camera.dart';

import '../../common/failure.dart';
import '../../data/data_sources/profilePicture/profile_picture.dart';
import '../../data/data_sources/s3/s3.dart';

Future<Failure?> uploadPhotoUnauthorized(
  String email,
  String password,
  XFile photo,
) =>
    ProfilePictureDataSource.getUploadUrlUnauthorized(email, password).then(
      (res) => res.fold(
        (url) => uploadPhoto(url, photo),
        (failure) => Future.value(failure),
      ),
    );

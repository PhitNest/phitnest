import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/profilePicture/profile_picture.dart';

abstract class ProfilePictureRepository {
  static Future<Either<String, Failure>> getUploadUrlUnauthorized(
    String email,
    String password,
  ) =>
      ProfilePictureDataSource.getUploadUrlUnauthorized(email, password);
}

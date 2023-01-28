import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/data_sources/profilePicture/profile_picture.dart';

abstract class ProfilePictureRepository {
  static FEither<String, Failure> getUploadUrlUnauthorized(
    String email,
    String password,
  ) =>
      ProfilePictureDataSource.getUploadUrlUnauthorized(email, password);
}

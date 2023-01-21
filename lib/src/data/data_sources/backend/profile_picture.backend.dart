import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../adapters/adapters.dart';
import '../../adapters/interfaces/interfaces.dart';

class ProfilePictureBackend {
  const ProfilePictureBackend();

  Future<Either<String, Failure>> getUploadUrlUnauthorized(
    String email,
    String cognitoId,
  ) =>
      httpAdapter.request(
        HttpMethod.get,
        '/profilePicture/unauthorized',
        data: {
          "email": email,
          "cognitoId": cognitoId,
        },
      ).then(
        (res) => res.fold(
          (response) => response.fold(
            (json) => Left(json['url']),
            (list) => Right(kInvalidBackendResponse),
          ),
          (failure) => Right(failure),
        ),
      );
}

const profilePictureBackend = ProfilePictureBackend();

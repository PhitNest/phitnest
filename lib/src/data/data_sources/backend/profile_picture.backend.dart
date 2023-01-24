import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../../common/failures.dart';
import '../../adapters/adapters.dart';
import '../../adapters/interfaces/interfaces.dart';
import 'backend.dart';

class ProfilePictureBackend {
  const ProfilePictureBackend();

  Future<Either<String, Failure>> getUploadUrlUnauthorized(
    String email,
    String password,
  ) =>
      httpAdapter.request(
        HttpMethod.get,
        Routes.getUploadUrlUnauthorized.path,
        data: {
          "email": email,
          "password": password,
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

import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../adapters/adapters.dart';

abstract class ProfilePictureDataSource {
  static Future<Either<String, Failure>> getUploadUrlUnauthorized(
    String email,
    String password,
  ) =>
      httpAdapter.request(
        Routes.getUploadUrlUnauthorized.instance,
        data: {
          "email": email,
          "password": password,
        },
      ).then(
        (res) => res.fold(
          (response) => response.fold(
            (json) => Left(json['url']),
            (list) => Right(Failures.invalidBackendResponse.instance),
          ),
          (failure) => Right(failure),
        ),
      );
}

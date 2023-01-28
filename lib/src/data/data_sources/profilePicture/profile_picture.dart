import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../adapters/adapters.dart';

abstract class ProfilePictureDataSource {
  static FEither<String, Failure> getUploadUrlUnauthorized(
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
          (json) => Left(json['url']),
          (list) => Right(Failures.invalidBackendResponse.instance),
          (failure) => Right(failure),
        ),
      );

  static FEither<String, Failure> profilePictureUpload() => httpAdapter
      .request(
        Routes.profilePictureUpload.instance,
      )
      .then(
        (res) => res.fold(
          (json) => Left(json['url']),
          (list) => Right(Failures.invalidBackendResponse.instance),
          (failure) => Right(failure),
        ),
      );
}

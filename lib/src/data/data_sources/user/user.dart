import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../adapters/adapters.dart';
import 'response/explore.dart';
import 'response/getUser.dart';

export 'cache.dart';

abstract class UserDataSource {
  static Future<Either<GetUserResponse, Failure>> getUser() => httpAdapter
      .request(
        Routes.getUser.instance,
      )
      .then(
        (either) => either.fold(
          (response) => response.fold(
            (json) => Left(GetUserResponse.fromJson(json)),
            (list) => Right(Failures.invalidBackendResponse.instance),
          ),
          (failure) => Right(failure),
        ),
      );

  static Future<Either<UserExploreResponse, Failure>> explore() => httpAdapter
      .request(
        Routes.explore.instance,
      )
      .then(
        (either) => either.fold(
          (response) => response.fold(
            (json) => Left(UserExploreResponse.fromJson(json)),
            (list) => Right(Failures.invalidBackendResponse.instance),
          ),
          (failure) => Right(failure),
        ),
      );
}

import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../adapters/adapters.dart';
import 'response/explore.dart';
import 'response/getUser.dart';

export 'cache.dart';

abstract class UserDataSource {
  static FEither<GetUserResponse, Failure> getUser() => httpAdapter
      .request(
        Routes.getUser.instance,
      )
      .then(
        (either) => either.fold(
          (json) => Left(GetUserResponse.fromJson(json)),
          (list) => Right(Failures.invalidBackendResponse.instance),
          (failure) => Right(failure),
        ),
      );

  static FEither<UserExploreResponse, Failure> explore() => httpAdapter
      .request(
        Routes.explore.instance,
      )
      .then(
        (response) => response.fold(
          (json) => Left(UserExploreResponse.fromJson(json)),
          (list) => Right(Failures.invalidBackendResponse.instance),
          (failure) => Right(failure),
        ),
      );
}

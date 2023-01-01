import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class GetUserUseCase implements IGetUserUseCase {
  @override
  Future<Either<UserEntity, Failure>> getUser() =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => userRepo.getUser(accessToken),
              (failure) => Right(failure),
            ),
          );
}

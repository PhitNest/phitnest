import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class GetGymUseCase implements IGetGymUseCase {
  @override
  Future<Either<GymEntity, Failure>> getGym() =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => gymRepo.getGym(accessToken),
              (failure) => Right(failure),
            ),
          );
}

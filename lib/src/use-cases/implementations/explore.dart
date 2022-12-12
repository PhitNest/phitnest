import 'package:dartz/dartz.dart';
import 'package:phitnest_mobile/src/use-cases/use_cases.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class ExploreUseCase implements IExploreUseCase {
  @override
  Future<Either<List<ExploreUserEntity>, Failure>> exploreUsers({
    int? skip,
    int? limit,
  }) =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => userRepo.getExploreUsers(
                accessToken,
                skip: skip,
                limit: limit,
              ),
              (failure) {
                if (memoryCacheRepo.myGym == null) {
                  return Right(
                    Failure("No gym selected."),
                  );
                }
                return userRepo.getTutorialExploreUsers(
                  memoryCacheRepo.myGym!.id,
                  skip: skip,
                  limit: limit,
                );
              },
            ),
          );
}

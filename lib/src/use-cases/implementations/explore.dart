import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../interfaces/interfaces.dart';

class ExploreUseCase implements IExploreUseCase {
  @override
  Future<Either<List<ExploreUserEntity>, Failure>> exploreUsers({
    int? skip,
    int? limit,
  }) async {
    if (memoryCacheRepo.myGym == null) {
      return Right(
        Failure("No gym selected."),
      );
    }
    if (memoryCacheRepo.me == null) {
      return userRepo.getTutorialExploreUsers(
        memoryCacheRepo.myGym!.id,
        skip: skip,
        limit: limit,
      );
    } else {
      return Right(
        Failure("Method not yet implemented."),
      );
    }
  }
}

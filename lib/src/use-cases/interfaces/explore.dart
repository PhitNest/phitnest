import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IExploreUseCase {
  Future<Either<List<ExploreUserEntity>, Failure>> exploreUsers({
    int? skip,
    int? limit,
  });
}

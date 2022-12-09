import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IRelationshipRepository {
  Future<Either<List<PublicUserEntity>, Failure>> getFriends(
      String accessToken);
}

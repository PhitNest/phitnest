import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IRelationshipRepository {
  Future<Either<List<FriendEntity>, Failure>> getFriends(String accessToken);
}

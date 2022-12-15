import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetFriendsUseCase {
  Future<Either<List<FriendEntity>, Failure>> friends();
}

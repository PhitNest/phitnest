import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetFriendRequestsUseCase {
  Future<Either<List<PublicUserEntity>, Failure>> getIncomingFriendRequests();
}

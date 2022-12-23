import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetFriendRequestsUseCase {
  Future<Either<Stream<PublicUserEntity>, Failure>> friendRequestStream();

  Future<Either<List<PublicUserEntity>, Failure>> getFriendRequests();
}

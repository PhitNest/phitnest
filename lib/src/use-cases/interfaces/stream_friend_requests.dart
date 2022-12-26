import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IStreamFriendRequestsUseCase {
  Future<Either<Stream<PublicUserEntity>, Failure>> streamFriendRequests();
}

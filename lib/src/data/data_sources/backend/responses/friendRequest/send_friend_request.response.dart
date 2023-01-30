import 'package:dartz/dartz.dart';

import '../../../../../common/utils/utils.dart';
import '../../../../../domain/entities/entities.dart';

class SendFriendRequestResponseParser
    extends Parser<Either<FriendRequestEntity, FriendshipEntity>> {
  const SendFriendRequestResponseParser() : super();

  @override
  Either<FriendRequestEntity, FriendshipEntity> fromJson(
      Map<String, dynamic> json) {
    try {
      return Left(FriendRequestParser().fromJson(json));
    } catch (_) {
      return Right(FriendshipParser().fromJson(json));
    }
  }
}

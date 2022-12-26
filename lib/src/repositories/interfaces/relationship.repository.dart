import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IRelationshipRepository {
  Future<Either<List<FriendEntity>, Failure>> getFriends(String accessToken);

  Future<Failure?> sendFriendRequest(
      String accessToken, String recipientCognitoId);

  Future<Either<Stream<PublicUserEntity>, Failure>> friendRequestStream(
      String accessToken);

  Future<Either<List<PublicUserEntity>, Failure>> getIncomingFriendRequests(
      String accessToken);

  Future<Failure?> denyFriendRequest(
      String accessToken, String recipientCognitoId);
}

import '../../entities/entities.dart';

abstract class IDenyFriendRequestUseCase {
  Future<Failure?> denyFriendRequest(String recipientCognitoId);
}

import '../../entities/entities.dart';

abstract class ISendFriendRequestUseCase {
  Future<Failure?> sendFriendRequest(String recipientCognitoId);
}

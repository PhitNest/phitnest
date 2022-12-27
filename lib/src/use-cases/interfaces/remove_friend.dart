import '../../entities/entities.dart';

abstract class IRemoveFriendUseCase {
  Future<Failure?> removeFriend(String recipientCognitoId);
}

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class SendFriendRequestUseCase implements ISendFriendRequestUseCase {
  Future<Failure?> sendFriendRequest(String recipientCognitoId) async =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => relationshipRepo.sendFriendRequest(
                accessToken,
                recipientCognitoId,
              ),
              (failure) => Future.value(failure),
            ),
          );
}

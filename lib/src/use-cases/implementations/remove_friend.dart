import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class RemoveFriendUseCase implements IRemoveFriendUseCase {
  @override
  Future<Failure?> removeFriend(
    String recipientCognitoId,
  ) =>
      getAuthTokenUseCase.getAccessToken().then(
            (result) => result.fold(
              (accessToken) => relationshipRepo.removeFriend(
                accessToken,
                recipientCognitoId,
              ),
              (failure) => Future.value(failure),
            ),
          );
}

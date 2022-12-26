import 'package:phitnest_mobile/src/entities/failure.entity.dart';

import '../../repositories/repositories.dart';
import '../use_cases.dart';

class DenyFriendRequestUseCase implements IDenyFriendRequestUseCase {
  @override
  Future<Failure?> denyFriendRequest(String recipientCognitoId) =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => relationshipRepo.denyFriendRequest(
                accessToken,
                recipientCognitoId,
              ),
              (failure) => failure,
            ),
          );
}

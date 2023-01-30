import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/adapters/adapters.dart';
import '../../data/data_sources/backend/backend.dart';
import '../entities/entities.dart';

abstract class GetDirectMessageRepository {
  static FEither<DirectMessageEntity, Failure> getDirectMessage(
    String friendCognitoId,
  ) async {
    final result = httpAdapter.request(
      kGetDirectMessagesRoute,
      GetDirectMessagesRequest(
        friendCognitoId: friendCognitoId,
      ),
    );

    return result;
  }
}

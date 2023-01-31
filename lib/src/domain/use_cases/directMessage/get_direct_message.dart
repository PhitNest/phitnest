import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../data/adapters/adapters.dart';
import '../../../data/data_sources/backend/backend.dart';
import '../../entities/entities.dart';

FEither<DirectMessageEntity, Failure> getDirectMessage(
  String friendCognitoId,
) async {
  final result = await httpAdapter.request(
    kGetDirectMessagesRoute,
    GetDirectMessagesRequest(
      friendCognitoId: friendCognitoId,
    ),
  );

  return result;
}

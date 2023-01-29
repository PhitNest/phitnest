import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';
import 'requests/requests.dart';

abstract class DirectMessageDataSource {
  static FEither<List<DirectMessageEntity>, Failure> getDirectMessages(
    String friendCognitoId,
  ) =>
      httpAdapter.requestList(
        Routes.getDirectMessages.instance,
        data: GetDirectMessagesRequest(friendCognitoId: friendCognitoId),
      );
}

import '../../../../domain/entities/entities.dart';
import '../requests/requests.dart';
import 'routes.dart';

const kGetDirectMessagesRoute =
    Route<GetDirectMessagesRequest, DirectMessageEntity>(
  "/directMessage/list",
  HttpMethod.get,
  DirectMessageParser(),
);

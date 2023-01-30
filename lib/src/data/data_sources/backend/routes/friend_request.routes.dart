import 'package:dartz/dartz.dart';

import '../../../../domain/entities/entities.dart';
import '../requests/requests.dart';
import '../responses/responses.dart';
import 'routes.dart';

const kSendFriendRequestRoute =
    Route<SendFriendRequest, Either<FriendRequestEntity, FriendshipEntity>>(
  '/friendRequest',
  HttpMethod.post,
  SendFriendRequestResponseParser(),
);

const kDenyFriendRequestRoute = Route<DenyFriendRequest, void>(
  '/friendRequest/deny',
  HttpMethod.post,
  Void(),
);

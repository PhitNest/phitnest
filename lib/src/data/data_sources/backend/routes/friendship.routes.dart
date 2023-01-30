import '../backend.dart';

const kFriendsAndMessagesRoute =
    Route<EmptyRequest, FriendsAndMessagesResponse>(
  '/friendship/friendsAndMessages',
  HttpMethod.get,
  FriendsAndMessagesResponseParser(),
);

const kFriendsAndRequestsRoute =
    Route<EmptyRequest, FriendsAndRequestsResponse>(
  '/friendship/friendsAndRequests',
  HttpMethod.get,
  FriendsAndRequestsResponseParser(),
);

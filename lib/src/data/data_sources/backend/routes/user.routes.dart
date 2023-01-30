import '../backend.dart';

const kExploreRoute = Route<UserExploreRequest, UserExploreResponse>(
  '/user/explore',
  HttpMethod.get,
  UserExploreResponseParser(),
);

const kGetUserRoute = Route<EmptyRequest, GetUserResponse>(
  '/user',
  HttpMethod.get,
  GetUserResponseParser(),
);

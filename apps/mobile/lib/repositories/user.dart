import 'package:core/core.dart';

import '../entities/entities.dart';

Future<HttpResponse<List<UserExplore>>> getExploreUsers(Session session) =>
    request(
      route: 'explore',
      method: HttpMethod.get,
      session: session,
      parse: (list) => (list as List<dynamic>)
          .map((json) => UserExplore.parse(json as Map<String, dynamic>))
          .toList(),
    );

Future<HttpResponse<GetUserResponseJson>> getUser(Session session) => request(
      route: 'user',
      method: HttpMethod.get,
      parse: (json) => GetUserResponseJson.parse(json as Map<String, dynamic>),
      session: session,
    );

Future<HttpResponse<void>> deleteUser(Session session) => request(
      route: 'user',
      method: HttpMethod.delete,
      parse: (_) {},
      session: session,
    );

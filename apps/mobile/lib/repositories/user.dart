import 'package:core/core.dart';

import '../entities/entities.dart';

Future<HttpResponse<List<User>>> getExploreUsers(Session session) => request(
      route: 'explore',
      method: HttpMethod.get,
      session: session,
      parse: (list) => (list as List<dynamic>)
          .map((json) => User.parse(json as Map<String, dynamic>))
          .toList(),
    );

Future<HttpResponse<User>> getUser(Session session) => request(
      route: 'user',
      method: HttpMethod.get,
      parse: (json) => User.parse(json as Map<String, dynamic>),
      session: session,
    );

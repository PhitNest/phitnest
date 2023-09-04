import 'package:core/core.dart';

import '../entities/entities.dart';

Future<HttpResponse<void>> createGym(
  CreateGymParams params,
  Session session,
) =>
    request(
      route: 'gym',
      method: HttpMethod.post,
      session: session,
      data: params.toJson(),
      parse: (_) {},
    );

Future<HttpResponse<void>> getGym(Session session) => request(
      route: 'gym/admin',
      method: HttpMethod.get,
      session: session,
      data: null,
      parse: (_){},
    );

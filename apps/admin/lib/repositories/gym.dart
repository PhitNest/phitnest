import 'package:core/core.dart';

import '../entities/entities.dart';

Future<HttpResponse<CreateGymSuccess>> createGym(
  CreateGymParams params,
  Session session,
) =>
    request(
      route: '/gym',
      method: HttpMethod.post,
      session: session,
      data: params.toJson(),
      parse: (json) => CreateGymSuccess.parse(json as Map<String, dynamic>),
    );

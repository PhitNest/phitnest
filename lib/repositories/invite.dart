import 'package:phitnest_core/core.dart';

import '../entities/entities.dart';

Future<HttpResponse<void>> adminInvite(
        AdminInviteParams params, Session session) =>
    request(
      route: '/adminInvite',
      method: HttpMethod.post,
      session: session,
      data: params.toJson(),
      parse: (_) {},
    );

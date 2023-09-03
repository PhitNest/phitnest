import 'package:core/core.dart';

import '../entities/entities.dart';

Future<HttpResponse<void>> createInvite(InviteParams params, Session session) =>
    request(
      route: 'admin-invite',
      method: HttpMethod.post,
      session: session,
      data: params.toJson(),
      parse: (_) {},
    );

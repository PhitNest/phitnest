import 'package:core/core.dart';

Future<HttpResponse<void>> createInvite(
        String receiverEmail, Session session) =>
    request(
      route: 'invite/admin',
      method: HttpMethod.post,
      session: session,
      data: {
        'receiverEmail': receiverEmail,
      },
      parse: (_) {},
    );

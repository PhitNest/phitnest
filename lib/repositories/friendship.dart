import 'package:phitnest_core/core.dart';

import '../entities/friendship.dart';

Future<HttpResponse<Friendship>> sendFriendRequest(
  String receiverId,
  Session session,
) =>
    request(
      route: '/friendship',
      method: HttpMethod.post,
      session: session,
      data: {
        'receiverId': receiverId,
      },
      parse: (json) =>
          Friendship.polymorphicParse(json as Map<String, dynamic>),
    );

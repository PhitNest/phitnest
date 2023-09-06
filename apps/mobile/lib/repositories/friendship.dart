import 'package:core/core.dart';

import '../entities/friendship.dart';

Future<HttpResponse<FriendshipResponse>> sendFriendRequest(
  String receiverId,
  Session session,
) =>
    request(
      route: 'friendship',
      method: HttpMethod.post,
      session: session,
      data: {
        'receiverId': receiverId,
      },
      parse: (json) =>
          FriendshipResponse.polymorphicParse(json as Map<String, dynamic>),
    );

Future<HttpResponse<void>> deleteFriendship(
  String receiverId,
  Session session,
) =>
    request(
      route: 'friendship',
      method: HttpMethod.delete,
      session: session,
      data: {
        'friendId': receiverId,
      },
      parse: (_) {},
    );

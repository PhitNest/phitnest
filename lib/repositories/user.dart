import 'package:phitnest_core/core.dart';

import '../entities/entities.dart';

Future<HttpResponse<List<UserExplore>>> exploreUsers(Session session) async {
  final exploreResponse = await request(
    route: '/explore',
    method: HttpMethod.get,
    session: session,
    parse: (list) => (list as List<dynamic>)
        .map((json) => User.parse(json as Map<String, dynamic>))
        .toList(),
  );
  switch (exploreResponse) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      final usersWithPictures = (await Future.wait(
        data.map(
          (user) async {
            final pfp = await getProfilePicture(user.identityId, session);
            if (pfp != null) {
              return UserExplore(
                user: user,
                profilePicture: pfp,
              );
            } else {
              return null;
            }
          },
        ).toList(),
      ))
          .where((element) => element != null)
          .cast<UserExplore>()
          .toList();
      return HttpResponseOk(usersWithPictures, headers);
    case HttpResponseFailure(failure: final failure, headers: final headers):
      return HttpResponseFailure(failure, headers);
  }
}

Future<HttpResponse<GetUserResponse>> getUser(Session session) async {
  final userResponse = await request(
    route: '/user',
    method: HttpMethod.get,
    parse: (json) => User.parse(json as Map<String, dynamic>),
    session: session,
  );
  switch (userResponse) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      final profilePicture = await getProfilePicture(data.identityId, session);
      if (profilePicture == null) {
        return HttpResponseOk(FailedToLoadProfilePicture(data), headers);
      } else {
        return HttpResponseOk(
          GetUserSuccess(
            User.populated(
              id: data.id,
              firstName: data.firstName,
              lastName: data.lastName,
              identityId: data.identityId,
            ),
            profilePicture,
          ),
          headers,
        );
      }
    case HttpResponseFailure(failure: final failure, headers: final headers):
      return HttpResponseFailure(failure, headers);
  }
}

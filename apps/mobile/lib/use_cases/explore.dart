import 'package:phitnest_core/core.dart';

import '../entities/entities.dart';
import '../repositories/repositories.dart';

Future<HttpResponse<List<UserExplore>>> exploreUsers(Session session) async {
  switch (await getExploreUsers(session)) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      final usersWithPictures = (await Future.wait(
        data.map(
          (user) async {
            final pfp = await getProfilePicture(user.identityId, session);
            return pfp != null
                ? UserExplore(user: user, profilePicture: pfp)
                : null;
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

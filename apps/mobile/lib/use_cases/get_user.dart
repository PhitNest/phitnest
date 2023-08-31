import 'package:phitnest_core/core.dart';

import '../entities/entities.dart';
import '../repositories/repositories.dart';

Future<HttpResponse<GetUserResponse>> user(Session session) async {
  switch (await getUser(session)) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      final profilePicture = await getProfilePicture(data.identityId, session);
      return HttpResponseOk(
          profilePicture != null
              ? GetUserSuccess(data, profilePicture)
              : FailedToLoadProfilePicture(data),
          headers);
    case HttpResponseFailure(failure: final failure, headers: final headers):
      return HttpResponseFailure(failure, headers);
  }
}

import 'package:core/core.dart';
import 'package:ui/ui.dart';

import '../entities/entities.dart';
import '../repositories/repositories.dart';

Future<HttpResponse<GetUserResponse>> user(Session session) async {
  switch (await getUser(session)) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      final profilePicture = await getProfilePicture(session, data.identityId);
      return HttpResponseOk(
        profilePicture != null
            ? GetUserSuccess(data, profilePicture)
            : FailedToLoadProfilePicture(data),
        headers,
      );
    case HttpResponseFailure(failure: final failure, headers: final headers):
      return HttpResponseFailure(failure, headers);
  }
}

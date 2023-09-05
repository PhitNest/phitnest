import 'package:core/core.dart';

import '../repositories/repositories.dart';

Future<HttpResponse<bool>> deleteUserAccount(Session session) =>
    deleteUser(session).then(
      (res) async => switch (res) {
        HttpResponseSuccess(headers: final headers) =>
          HttpResponseOk(await deleteAccount(session), headers),
        HttpResponseFailure(failure: final failure, headers: final headers) =>
          HttpResponseFailure(failure, headers),
      },
    );

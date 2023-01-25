import '../../common/failure.dart';
import '../../data/data_sources/backend/backend.dart';

Future<Failure?> resetPassword(
  String email,
) =>
    authBackend.forgotPassword(email).then(
      (response) {
        if (response == null) {
          return null;
        } else {
          return response;
        }
      },
    );

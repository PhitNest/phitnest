import '../../../common/failure.dart';
import '../../../data/adapters/adapters.dart';
import '../../../data/data_sources/backend/backend.dart';

Future<Failure?> resendConfirmation(
  String email,
) =>
    httpAdapter.requestVoid(
      kResendConfirmationRoute,
      ResendConfirmationRequest(
        email: email,
      ),
    );

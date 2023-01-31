import '../../../common/failure.dart';
import '../../../data/adapters/adapters.dart';
import '../../../data/data_sources/backend/backend.dart';

Future<Failure?> forgotPassword(
  String email,
) =>
    httpAdapter.requestVoid(
      kForgotPasswordRoute,
      ForgotPasswordRequest(
        email: email,
      ),
    );

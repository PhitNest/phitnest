import '../../common/failure.dart';
import '../../data/adapters/adapters.dart';
import '../../data/data_sources/backend/backend.dart';

Future<Failure?> forgotPassword(
  String email,
) =>
    httpAdapter
        .request(
          kForgotPasswordRoute,
          ForgotPasswordRequest(
            email: email,
          ),
        )
        .then(
          (result) => result.fold(
            (_) => null,
            (failure) => failure,
          ),
        );

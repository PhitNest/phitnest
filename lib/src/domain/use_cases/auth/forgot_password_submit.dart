import '../../../common/failure.dart';
import '../../../data/adapters/adapters.dart';
import '../../../data/data_sources/backend/backend.dart';

Future<Failure?> forgotPasswordSubmit(
  String email,
  String password,
  String code,
) =>
    httpAdapter
        .request(
          kForgotPasswordSubmitRoute,
          ForgotPasswordSubmitRequest(
            email: email,
            password: password,
            code: code,
          ),
        )
        .then(
          (result) => result.fold(
            (_) => null,
            (failure) => failure,
          ),
        );

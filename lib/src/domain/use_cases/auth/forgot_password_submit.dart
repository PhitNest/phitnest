import '../../../common/failure.dart';
import '../../../data/adapters/adapters.dart';
import '../../../data/data_sources/backend/backend.dart';

Future<Failure?> forgotPasswordSubmit(
  String email,
  String password,
  String code,
) =>
    httpAdapter.requestVoid(
      kForgotPasswordSubmitRoute,
      ForgotPasswordSubmitRequest(
        email: email,
        password: password,
        code: code,
      ),
    );

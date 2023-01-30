import '../../common/failure.dart';
import '../../data/adapters/adapters.dart';
import '../../data/data_sources/backend/backend.dart';

Future<Failure?> confirmRegister(
  String email,
  String code,
) =>
    httpAdapter
        .request(
          kConfirmRegisterRoute,
          ConfirmRegisterRequest(
            email: email,
            code: code,
          ),
        )
        .then(
          (either) => either.fold(
            (_) => null,
            (failure) => failure,
          ),
        );

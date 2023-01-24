import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../common/failures.dart';
import '../repositories/repositories.dart';

Future<Either<bool, Failure>> resetPassword(
  String email,
  String password,
) =>
    authRepo.forgotPassword(email, password).then(
      (res) {
        if (res.isLeft()) {
          return Left(true);
        } else {
          return Right(kInvalidBackendResponse);
        }
      },
    );

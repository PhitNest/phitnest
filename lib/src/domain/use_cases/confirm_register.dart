import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

Future<Either<UserEntity, Failure>> confirmRegister(
  String email,
  String code,
) =>
    AuthRepository.confirmRegister(email, code);

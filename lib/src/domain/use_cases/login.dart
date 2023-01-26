import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/auth/auth.dart';
import '../repositories/repositories.dart';

Future<Either<LoginResponse, Failure>> login(
  String email,
  String password,
) =>
    AuthRepository.login(email, password);

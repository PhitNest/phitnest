import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/data_sources/auth/auth.dart';
import '../repositories/repositories.dart';

FEither<LoginResponse, Failure> login(
  String email,
  String password,
) =>
    AuthRepository.login(email, password);

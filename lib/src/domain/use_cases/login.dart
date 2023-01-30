import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/data_sources/backend/backend.dart';
import '../repositories/repositories.dart';

FEither<LoginResponse, Failure> login(
  String email,
  String password,
) =>
    AuthRepository.login(email, password);

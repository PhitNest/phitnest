import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/data_sources/auth/auth.dart';
import '../repositories/repositories.dart';

FEither<RegisterResponse, Failure> register(
  String firstName,
  String lastName,
  String email,
  String password,
  String gymId,
) =>
    AuthRepository.register(firstName, lastName, email, password, gymId);

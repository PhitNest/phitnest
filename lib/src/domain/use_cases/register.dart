import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/data_sources/backend/backend.dart';
import '../repositories/repositories.dart';

FEither<RegisterResponse, Failure> register(
  String email,
  String password,
  String firstName,
  String lastName,
  String gymId,
) =>
    AuthRepository.register(email, password, firstName, lastName, gymId);

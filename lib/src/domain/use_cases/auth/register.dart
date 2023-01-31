import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../data/data_sources/backend/backend.dart';
import '../../repositories/repositories.dart';

FEither<RegisterResponse, Failure> register(
  String firstName,
  String lastName,
  String email,
  String password,
  String gymId,
) =>
    AuthRepository.register(firstName, lastName, email, password, gymId);

import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

FEither<UserEntity, Failure> confirmRegister(
  String email,
  String code,
) =>
    AuthRepository.confirmRegister(email, code);

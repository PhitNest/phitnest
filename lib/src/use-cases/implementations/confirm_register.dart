import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../interfaces/interfaces.dart';

class ConfirmRegisterUseCase implements IConfirmRegisterUseCase {
  @override
  Future<Failure?> confirmRegister(String email, String code) =>
      authRepo.confirmRegister(email, code);

  @override
  Future<Failure?> resendConfirmation(String email) =>
      authRepo.resendConfirmation(email);
}

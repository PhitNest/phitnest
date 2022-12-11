import '../../entities/entities.dart';

abstract class IConfirmRegisterUseCase {
  Future<Failure?> confirmRegister(String email, String code);

  Future<Failure?> resendConfirmation(String email);
}

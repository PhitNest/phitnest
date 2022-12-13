import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../interfaces/interfaces.dart';

class ForgotPasswordUseCase implements IForgotPasswordUseCase {
  @override
  Future<Failure?> forgotPassword(String email) =>
      authRepo.forgotPassword(email);

  @override
  Future<Failure?> resetPassword(
    String email,
    String code,
    String newPassword,
  ) =>
      authRepo.resetPassword(email, code, newPassword);
}

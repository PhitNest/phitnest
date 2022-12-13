import '../../entities/entities.dart';

abstract class IForgotPasswordUseCase {
  Future<Failure?> forgotPassword(String email);

  Future<Failure?> resetPassword(
    String email,
    String code,
    String newPassword,
  );
}

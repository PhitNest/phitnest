import '../../entities/entities.dart';

abstract class IRegisterUseCase {
  Future<Failure?> register(
    String email,
    String password,
    String firstName,
    String lastName,
  );
}

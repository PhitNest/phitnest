import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../interfaces/interfaces.dart';

class RegisterUseCase implements IRegisterUseCase {
  Future<Failure?> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async =>
      memoryCacheRepo.myGym != null
          ? await authRepo
              .register(email, password, memoryCacheRepo.myGym!.id, firstName,
                  lastName)
              .then((value) {
              if (value == null) {
                memoryCacheRepo.email = email;
                memoryCacheRepo.password = password;
                deviceCacheRepo.setEmail(email);
                deviceCacheRepo.setPassword(password);
              }
              return value;
            })
          : Failure("No gym selected.");
}

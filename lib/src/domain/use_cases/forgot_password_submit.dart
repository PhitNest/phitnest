import '../../common/failure.dart';
import '../repositories/repositories.dart';

Future<Failure?> forgotPasswordSubmit(
  String email,
  String password,
  String code,
) =>
    AuthRepository.forgotPasswordSubmit(email, password, code);

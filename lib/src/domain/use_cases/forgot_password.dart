import '../../common/failure.dart';
import '../repositories/repositories.dart';

Future<Failure?> forgotPassword(String email) =>
    AuthRepository.forgotPassword(email);

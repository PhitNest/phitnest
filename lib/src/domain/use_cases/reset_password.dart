import '../../common/failure.dart';
import '../repositories/repositories.dart';

Future<Failure?> resetPassword(String email) =>
    AuthRepository.forgotPassword(email);

import '../../common/failure.dart';
import '../repositories/repositories.dart';

Future<Failure?> resendConfirmationCode(String email) =>
    AuthRepository.resendConfirmationCode(email);

import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/auth/auth.dart';
import '../../data/data_sources/user/user.dart';
import '../entities/entities.dart';

abstract class AuthRepository {
  static Future<Either<LoginResponse, Failure>> login(
    String email,
    String password,
  ) async {
    final response = await AuthDataSource.login(email, password);
    if (response.isLeft()) {
      await cacheEmail(email);
      await cachePassword(password);
      await response.fold(
        (response) async {
          await cacheUser(response.user);
          await cacheAccessToken(response.session.accessToken);
          await cacheRefreshToken(response.session.refreshToken);
        },
        (failure) => throw Exception("This should not happen."),
      );
    }
    return response;
  }

  static Future<Either<RegisterResponse, Failure>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String gymId,
  ) async {
    final response = await AuthDataSource.register(
      firstName,
      lastName,
      email,
      password,
      gymId,
    );
    if (response.isLeft()) {
      await cacheEmail(email);
      await cachePassword(password);
      await cacheUser(
        response
            .swap()
            .getOrElse(() => throw Exception("This should not happen."))
            .user,
      );
    }
    return response;
  }

  static Future<Failure?> forgotPassword(
    String email,
  ) =>
      AuthDataSource.forgotPassword(email);

  static Future<Failure?> forgotPasswordSubmit(
          String email, String password, String code) =>
      AuthDataSource.forgotPasswordSubmit(email, password, code);

  static Future<Failure?> resendConfirmationCode(String email) =>
      AuthDataSource.resendConfirmationCode(email);

  static Future<Either<UserEntity, Failure>> confirmRegister(
    String email,
    String code,
  ) async {
    final result = await AuthDataSource.confirmRegister(email, code);
    if (result.isLeft()) {
      await cacheUser(
        result.swap().getOrElse(
              () => throw Exception("This should not happen."),
            ),
      );
    }
    return result;
  }
}

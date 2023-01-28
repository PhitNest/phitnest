import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';
import 'responses/responses.dart';

export 'cache.dart';
export 'responses/responses.dart';

abstract class AuthDataSource {
  static FEither<LoginResponse, Failure> login(
    String email,
    String password,
  ) =>
      httpAdapter.request(
        Routes.login.instance,
        data: {
          'email': email,
          'password': password,
        },
      ).then(
        (either) => either.fold(
          (json) => Left(LoginResponse.fromJson(json)),
          (list) => Right(Failures.invalidBackendResponse.instance),
          (failure) => Right(failure),
        ),
      );

  static FEither<RegisterResponse, Failure> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gymId,
  ) =>
      httpAdapter.request(
        Routes.register.instance,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'gymId': gymId,
        },
      ).then(
        (either) => either.fold(
          (json) => Left(RegisterResponse.fromJson(json)),
          (list) => Right(Failures.invalidBackendResponse.instance),
          (failure) => Right(failure),
        ),
      );

  static Future<Failure?> forgotPassword(
    String email,
  ) =>
      httpAdapter.request(
        Routes.forgotPassword.instance,
        data: {
          'email': email,
        },
      ).then(
        (either) => either.fold(
          (json) => null,
          (list) => Failures.invalidBackendResponse.instance,
          (failure) => failure,
        ),
      );

  static Future<Failure?> resendConfirmationCode(String email) =>
      httpAdapter.request(
        Routes.resendConfirmationCode.instance,
        data: {
          'email': email,
        },
      ).then(
        (either) => either.fold(
          (json) => null,
          (list) => Failures.invalidBackendResponse.instance,
          (failure) => failure,
        ),
      );

  static FEither<UserEntity, Failure> confirmRegister(
    String email,
    String code,
  ) =>
      httpAdapter.request(
        Routes.confirmRegister.instance,
        data: {
          'email': email,
          'code': code,
        },
      ).then(
        (response) => response.fold(
          (json) => Left(UserEntity.fromJson(json)),
          (list) => Right(Failures.invalidBackendResponse.instance),
          (failure) => Right(failure),
        ),
      );

  static Future<Failure?> forgotPasswordSubmit(
    String email,
    String password,
    String code,
  ) =>
      httpAdapter.request(
        Routes.forgotPasswordSubmit.instance,
        data: {
          'email': email,
          'code': code,
          'newPassword': password,
        },
      ).then(
        (either) => either.fold(
          (json) => null,
          (list) => Failures.invalidCode.instance,
          (failure) => failure,
        ),
      );

  static FEither<RefreshTokenResponse, Failure> refreshSession(
    String email,
    String refreshToken,
  ) =>
      httpAdapter.request(Routes.refreshSession.instance, data: {
        'email': email,
        'refreshToken': refreshToken,
      }).then(
        (either) => either.fold(
          (json) => Left(RefreshTokenResponse.fromJson(json)),
          (list) => Right(Failures.invalidBackendResponse.instance),
          (failure) => Right(failure),
        ),
      );

  static Future<Failure?> signOut(bool allDevices) => httpAdapter.request(
        Routes.signOut.instance,
        data: {
          "allDevices": allDevices,
        },
      ).then(
        (either) => either.fold(
          (json) => null,
          (list) => Failures.invalidBackendResponse.instance,
          (failure) => failure,
        ),
      );
}

import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';
import 'responses/responses.dart';

export 'cache.dart';
export 'responses/responses.dart';

abstract class AuthDataSource {
  static Future<Either<LoginResponse, Failure>> login(
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
          (response) => response.fold(
            (json) => Left(LoginResponse.fromJson(json)),
            (list) => Right(Failures.invalidBackendResponse.instance),
          ),
          (failure) => Right(failure),
        ),
      );

  static Future<Either<RegisterResponse, Failure>> register(
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
          (response) => response.fold(
            (json) => Left(RegisterResponse.fromJson(json)),
            (list) => Right(Failures.invalidBackendResponse.instance),
          ),
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
          (response) => response.fold(
            (json) => null,
            (list) => Failures.invalidBackendResponse.instance,
          ),
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
          (response) => response.fold(
            (json) => null,
            (list) => Failures.invalidBackendResponse.instance,
          ),
          (failure) => failure,
        ),
      );

  static Future<Either<UserEntity, Failure>> confirmRegister(
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
        (either) => either.fold(
          (response) => response.fold(
            (json) => Left(UserEntity.fromJson(json)),
            (list) => Right(Failures.invalidBackendResponse.instance),
          ),
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
          (response) => response.fold(
            (json) => null,
            (list) => Failures.invalidCode.instance,
          ),
          (failure) => failure,
        ),
      );
}

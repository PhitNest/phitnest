import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';

import '../../services/services.dart';
import '../repositories.dart';

class AuthenticationRepository implements IAuthRepository {
  Future<bool> validAccessToken(String accessToken) async {
    if (!Jwt.isExpired(accessToken)) {
      return await restService
          .get(
            kAuth,
            accessToken: accessToken,
            timeout: const Duration(seconds: 1),
          )
          .then(
            (either) => either.fold(
              (res) => res.statusCode == 200,
              (failure) => false,
            ),
          );
    } else {
      return false;
    }
  }

  Future<Either<AuthTokensEntity, Failure>> login(
    String email,
    String password, {
    Duration? timeout,
  }) =>
      restService
          .post(
            kLogin,
            body: {
              'email': email,
              'password': password,
            },
            timeout: timeout,
          )
          .then(
            (either) => either.fold(
              (res) => Left(
                AuthTokensEntity.fromJson(
                  jsonDecode(res.body),
                ),
              ),
              (failure) => Right(
                Failure("Invalid email or password."),
              ),
            ),
          );

  Future<Failure?> register(String email, String password, String gymId,
          String firstName, String lastName) =>
      restService.post(
        kRegister,
        body: {
          'email': email,
          'password': password,
          'gymId': gymId,
          'firstName': firstName,
          'lastName': lastName
        },
      ).then(
        (either) => either.fold(
            (res) => res.statusCode == kStatusCreated
                ? null
                : Failure("Invalid credentials"),
            (failure) => failure),
      );

  @override
  Future<Either<SessionRefreshTokensEntity, Failure>> refreshSession(
    String email,
    String refreshToken, {
    Duration? timeout,
  }) =>
      restService
          .post(
            kRefreshSession,
            body: {
              'email': email,
              'refreshToken': refreshToken,
            },
            timeout: timeout,
          )
          .then(
            (either) => either.fold(
              (response) {
                if (response.statusCode == kStatusOK) {
                  return Left(
                    SessionRefreshTokensEntity.fromJson(
                      jsonDecode(response.body),
                    ),
                  );
                } else {
                  return Right(
                    Failure(response.body),
                  );
                }
              },
              (failure) => Right(failure),
            ),
          );
}

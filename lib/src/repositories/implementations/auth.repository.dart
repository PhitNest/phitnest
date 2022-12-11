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
              (res) => res.statusCode == kStatusOK
                  ? Left(
                      AuthTokensEntity.fromJson(
                        jsonDecode(res.body),
                      ),
                    )
                  : Right(
                      Failure(jsonDecode(res.body).toString()),
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
        (either) => either.fold((res) {
          if (res.statusCode == kStatusCreated) {
            return null;
          } else {
            final body = jsonDecode(res.body);
            if (body is List) {
              if (body[0]['validation'] == 'email') {
                return Failure("Please enter a valid email.");
              } else {
                return Failure("Please enter a valid password.");
              }
            }
            return Failure(body.toString());
          }
        }, (failure) => failure),
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
              (response) => response.statusCode == kStatusOK
                  ? Left(
                      SessionRefreshTokensEntity.fromJson(
                        jsonDecode(response.body),
                      ),
                    )
                  : Right(
                      Failure(jsonDecode(response.body).toString()),
                    ),
              (failure) => Right(failure),
            ),
          );
}

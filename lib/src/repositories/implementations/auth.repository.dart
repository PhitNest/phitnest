import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../common/utils.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import 'package:http/http.dart' as http;

import '../../failures/failures.dart';
import '../repositories.dart';

class AuthenticationRepository implements IAuthRepository {
  Future<bool> validAccessToken(String accessToken) async {
    if (!Jwt.isExpired(accessToken)) {
      return http.get(
        getBackendAddress(kAuth),
        headers: {
          "authorization": "Bearer $accessToken",
        },
      ).then(
        (res) => res.statusCode == 200,
      );
    } else {
      return false;
    }
  }

  Future<Either<AuthTokensEntity, Failure>> login(
          String email, String password) =>
      http.post(
        getBackendAddress(kLogin),
        body: {
          'email': email,
          'password': password,
        },
      ).then(
        (response) => response.statusCode == kStatusOK
            ? Left(
                AuthTokensEntity.fromJson(
                  jsonDecode(response.body),
                ),
              )
            : Right(
                Failure.fromResponse(
                  response.statusCode,
                  jsonDecode(response.body),
                ),
              ),
      );

  Future<Failure?> register(String email, String password, String gymId,
          String firstName, String lastName) =>
      http.post(
        getBackendAddress(kRegister),
        body: {
          'email': email,
          'password': password,
          'gymId': gymId,
          'firstName': firstName,
          'lastName': lastName
        },
      ).then(
        (response) => response.statusCode == kStatusCreated
            ? null
            : Failure.fromResponse(
                response.statusCode,
                jsonDecode(response.body),
              ),
      );

  @override
  Future<Either<SessionRefreshTokensEntity, Failure>> refreshSession(
          String email, String refreshToken) =>
      http.post(
        getBackendAddress(kRefreshSession),
        body: {
          'email': email,
          'refreshToken': refreshToken,
        },
      ).then(
        (response) => response.statusCode == kStatusOK
            ? Left(
                SessionRefreshTokensEntity.fromJson(
                  jsonDecode(response.body),
                ),
              )
            : Right(
                Failure.fromResponse(
                  response.statusCode,
                  jsonDecode(response.body),
                ),
              ),
      );
}

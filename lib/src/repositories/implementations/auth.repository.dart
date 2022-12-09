import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../common/utils.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import 'package:http/http.dart' as http;

import '../repositories.dart';

class AuthenticationRepository implements IAuthRepository {
  Future<bool> validAccessToken(String accessToken) async {
    if (!Jwt.isExpired(accessToken)) {
      try {
        return await http
            .get(
              getBackendAddress(kAuth),
              headers: {
                "authorization": "Bearer $accessToken",
              },
            )
            .timeout(
              const Duration(seconds: 1),
            )
            .then(
              (res) => res.statusCode == 200,
            );
      } catch (err) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<Either<AuthTokensEntity, Failure>> login(
      String email, String password) async {
    try {
      return await http
          .post(
            getBackendAddress(kLogin),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(requestTimeout)
          .then(
        (response) {
          if (response.statusCode == kStatusOK) {
            return Left(
              AuthTokensEntity.fromJson(
                jsonDecode(response.body),
              ),
            );
          } else {
            return Right(
              Failure("Invalid email or password."),
            );
          }
        },
      );
    } catch (err) {
      return Right(
        Failure("Could not connect to network."),
      );
    }
  }

  Future<Failure?> register(String email, String password, String gymId,
      String firstName, String lastName) async {
    try {
      return await http
          .post(
            getBackendAddress(kRegister),
            body: {
              'email': email,
              'password': password,
              'gymId': gymId,
              'firstName': firstName,
              'lastName': lastName
            },
          )
          .timeout(requestTimeout)
          .then(
            (response) {
              if (response.statusCode == kStatusCreated) {
                return null;
              } else {
                final json = jsonDecode(response.body);
                if (json is List<dynamic>) {
                  return Failure("Formatting error");
                }
                return Failure(response.body);
              }
            },
          );
    } catch (err) {
      return Failure("Could not connect to network.");
    }
  }

  @override
  Future<Either<SessionRefreshTokensEntity, Failure>> refreshSession(
      String email, String refreshToken) async {
    try {
      return await http
          .post(
            getBackendAddress(kRefreshSession),
            body: {
              'email': email,
              'refreshToken': refreshToken,
            },
          )
          .timeout(requestTimeout)
          .then(
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
          );
    } catch (err) {
      return Right(
        Failure("Could not connect to network."),
      );
    }
  }
}

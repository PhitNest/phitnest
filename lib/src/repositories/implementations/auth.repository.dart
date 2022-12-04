import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import 'package:http/http.dart' as http;

import '../../failures/failures.dart';
import '../repositories.dart';
import 'implementations.dart';

class AuthenticationRepository implements IAuthRepository {
  Future<Either<AuthTokensEntity, Failure>> login(
          String email, String password) =>
      http.post(repositories<EnvironmentRepository>().getBackendAddress(kLogin),
          body: {'email': email, 'password': password}).then((response) {
        final body = jsonDecode(response.body);
        return response.statusCode == kStatusOK
            ? Left(
                AuthTokensEntity.fromJson(body),
              )
            : Right(
                Failure.fromResponse(response.statusCode, body),
              );
      });

  Future<String?> register(String email, String password, String gymId,
          String firstName, String lastName) =>
      http.post(
          repositories<EnvironmentRepository>().getBackendAddress(kRegister),
          body: {
            'email': email,
            'password': password,
            'gymId': gymId,
            'firstName': firstName,
            'lastName': lastName
          }).then((response) =>
          response.statusCode == kStatusCreated ? null : response.body);

  @override
  Future<Either<SessionRefreshTokensEntity, Failure>> refreshSession(
          String email, String refreshToken) =>
      http.post(
          repositories<EnvironmentRepository>()
              .getBackendAddress(kRefreshSession),
          body: {
            'email': email,
            'refreshToken': refreshToken
          }).then((response) {
        final body = jsonDecode(response.body);
        return response.statusCode == kStatusOK
            ? Left(
                AuthTokensEntity.fromJson(body),
              )
            : Right(
                Failure.fromResponse(response.statusCode, body),
              );
      });
}

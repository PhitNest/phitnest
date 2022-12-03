import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import 'package:http/http.dart' as http;

import '../repositories.dart';
import 'implementations.dart';

class AuthenticationRepository implements IAuthRepository {
  Future<Either<AuthTokensEntity, String>> login(
          String email, String password) =>
      http.post(repositories<EnvironmentRepository>().getBackendAddress(kLogin),
          body: {
            'email': email,
            'password': password
          }).then((response) => response.statusCode == kStatusOK
          ? Left(AuthTokensEntity.fromJson(jsonDecode(response.body)))
          : Right(response.body));

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
}

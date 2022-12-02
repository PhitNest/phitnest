import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../models/models.dart';
import 'package:http/http.dart' as http;

import '../repositories.dart';

class AuthenticationRepository {
  Future<Either<AuthTokens, String>> login(String email, String password) =>
      http.post(
          repositories<EnvironmentRepository>()
              .getBackendAddress('/auth/login'),
          body: {
            'email': email,
            'password': password
          }).then((response) => response.statusCode == 200
          ? Left(AuthTokens.fromJson(jsonDecode(response.body)))
          : Right(response.body));
}

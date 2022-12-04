import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../entities/entities.dart';
import '../../failures/failures.dart';
import '../repositories.dart';

class UserRepository implements IUserRepository {
  @override
  getUser(String accessToken) => http.post(
          repositories<IEnvironmentRepository>().getBackendAddress('/user'),
          headers: {"authorization": "Bearer $accessToken"}).then((response) {
        final body = jsonDecode(response.body);
        return response.statusCode == 200
            ? Left(UserEntity.fromJson(body))
            : Right(Failure.fromResponse(response.statusCode, body));
      });
}

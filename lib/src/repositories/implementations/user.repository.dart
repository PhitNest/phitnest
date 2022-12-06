import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../common/utils.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../../failures/failures.dart';
import '../repositories.dart';

class UserRepository implements IUserRepository {
  @override
  getUser(String accessToken) => http.post(
        getBackendAddress(kGetUser),
        headers: {"authorization": "Bearer $accessToken"},
      ).then(
        (response) => response.statusCode == 200
            ? Left(
                UserEntity.fromJson(
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

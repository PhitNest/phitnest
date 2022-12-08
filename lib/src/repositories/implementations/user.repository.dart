import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../common/utils.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../repositories.dart';

class UserRepository implements IUserRepository {
  @override
  getUser(String accessToken) => http.post(
        getBackendAddress(kGetUser),
        headers: {"authorization": "Bearer $accessToken"},
      ).then(
        (response) {
          if (response.statusCode == kStatusOK) {
            return Left(
              UserEntity.fromJson(
                jsonDecode(response.body),
              ),
            );
          } else {
            return Right(
              Failure(
                type: FailureType.unknown,
              ),
            );
          }
        },
      );
}

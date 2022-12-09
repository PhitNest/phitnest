import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../common/utils.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../repositories.dart';

class UserRepository implements IUserRepository {
  @override
  getUser(String accessToken) async {
    try {
      return await http
          .get(
            getBackendAddress(kGetUser),
            headers: {"authorization": "Bearer $accessToken"},
          )
          .timeout(requestTimeout)
          .then(
            (response) {
              if (response.statusCode == kStatusOK) {
                return Left(
                  UserEntity.fromJson(
                    jsonDecode(response.body),
                  ),
                );
              } else {
                return Right(
                  Failure("Failed to get user."),
                );
              }
            },
          );
    } catch (err) {
      return Right(
        Failure("Failed to connect to the network."),
      );
    }
  }

  @override
  Future<Either<List<ExploreUserEntity>, Failure>> getExploreUsers(
      String accessToken,
      {int? skip,
      int? limit}) async {
    try {
      return await http
          .get(
              getBackendAddress(
                kExplore,
                params: {
                  ...(skip != null ? {"skip": skip.toString()} : {}),
                  ...(limit != null ? {"limit": limit.toString()} : {}),
                },
              ),
              headers: {
                "authorization": "Bearer $accessToken",
              })
          .timeout(requestTimeout)
          .then(
            (response) {
              if (response.statusCode == kStatusOK) {
                final json = jsonDecode(response.body);
                if (json is List) {
                  return Left(
                    json
                        .map(
                          (e) => ExploreUserEntity.fromJson(e),
                        )
                        .toList(),
                  );
                }
              }
              return Right(
                Failure("Failed to get users."),
              );
            },
          );
    } catch (err) {
      return Right(
        Failure("Failed to connect to the network."),
      );
    }
  }

  @override
  Future<Either<List<ExploreUserEntity>, Failure>> getTutorialExploreUsers(
      String gymId,
      {int? skip,
      int? limit}) async {
    try {
      return await http
          .get(
            getBackendAddress(kTutorialExplore, params: {
              "gymId": gymId,
              ...(skip != null ? {"skip": skip.toString()} : {}),
              ...(limit != null ? {"limit": limit.toString()} : {}),
            }),
          )
          .timeout(requestTimeout)
          .then(
        (response) {
          if (response.statusCode == kStatusOK) {
            final json = jsonDecode(response.body);
            if (json is List) {
              return Left(
                json
                    .map(
                      (e) => ExploreUserEntity.fromJson(e),
                    )
                    .toList(),
              );
            }
          }
          return Right(
            Failure("Failed to get users."),
          );
        },
      );
    } catch (err) {
      return Right(
        Failure("Failed to connect to the network."),
      );
    }
  }
}

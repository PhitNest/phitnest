import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../../services/services.dart';
import '../repositories.dart';

class UserRepository implements IUserRepository {
  @override
  getUser(String accessToken) => restService
      .get(
        kGetUser,
        accessToken: accessToken,
      )
      .then(
        (either) => either.fold(
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
          (failure) => Right(failure),
        ),
      );

  @override
  Future<Either<List<ExploreUserEntity>, Failure>> getExploreUsers(
    String accessToken, {
    int? skip,
    int? limit,
  }) =>
      restService
          .get(
            kExplore,
            accessToken: accessToken,
            params: {
              ...(skip != null ? {"skip": skip.toString()} : {}),
              ...(limit != null ? {"limit": limit.toString()} : {}),
            },
            timeout: requestTimeout,
          )
          .then(
            (either) => either.fold(
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
              (failure) => Right(failure),
            ),
          );

  @override
  Future<Either<List<ExploreUserEntity>, Failure>> getTutorialExploreUsers(
    String gymId, {
    int? skip,
    int? limit,
  }) =>
      restService
          .get(
            kTutorialExplore,
            params: {
              "gymId": gymId,
              ...(skip != null ? {"skip": skip.toString()} : {}),
              ...(limit != null ? {"limit": limit.toString()} : {}),
            },
            timeout: requestTimeout,
          )
          .then(
            (either) => either.fold(
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
              (failure) => Right(failure),
            ),
          );
}

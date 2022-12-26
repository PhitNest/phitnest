import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../../services/services.dart';
import '../interfaces/interfaces.dart';

class RelationshipRepository implements IRelationshipRepository {
  @override
  Future<Either<List<FriendEntity>, Failure>> getFriends(String accessToken) =>
      restService
          .get(
            kFriends,
            accessToken: accessToken,
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
                            (friend) => FriendEntity.fromJson(friend),
                          )
                          .toList(),
                    );
                  }
                }
                return Right(
                  Failure(jsonDecode(response.body).toString()),
                );
              },
              (failure) => Right(failure),
            ),
          );

  @override
  Future<Either<Stream<PublicUserEntity>, Failure>> friendRequestStream(
          String accessToken) async =>
      (await eventService.stream(kFriendRequest, accessToken)).fold(
        (stream) => Left(
          stream.map(
            (json) => PublicUserEntity.fromJson(json),
          ),
        ),
        (failure) => Right(failure),
      );

  @override
  Future<Failure?> sendFriendRequest(
    String accessToken,
    String recipientCognitoId,
  ) async =>
      (await eventService.emit(
        kFriendRequest,
        {
          "recipientId": recipientCognitoId,
        },
        accessToken,
      ))
          .fold(
        (success) => null,
        (failure) => failure,
      );

  @override
  Future<Either<List<PublicUserEntity>, Failure>> getIncomingFriendRequests(
          String accessToken) =>
      restService
          .get(
            kGetIncomingFriendRequests,
            accessToken: accessToken,
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
                            (friend) => PublicUserEntity.fromJson(friend),
                          )
                          .toList(),
                    );
                  }
                }
                return Right(
                  Failure(jsonDecode(response.body).toString()),
                );
              },
              (failure) => Right(failure),
            ),
          );

  @override
  Future<Failure?> denyFriendRequest(
          String accessToken, String recipientCognitoId) =>
      restService
          .post(
            kDenyFriendRequest,
            body: {
              "recipientId": recipientCognitoId,
            },
            accessToken: accessToken,
          )
          .then(
            (either) => either.fold(
              (response) => response.statusCode == kStatusOK
                  ? null
                  : Failure(jsonDecode(response.body).toString()),
              (failure) => failure,
            ),
          );
}

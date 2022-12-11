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
                  Failure("Failed to get friends."),
                );
              },
              (failure) => Right(failure),
            ),
          );
}

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../common/utils.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';

class RelationshipRepository implements IRelationshipRepository {
  @override
  Future<Either<List<PublicUserEntity>, Failure>> getFriends(
      String accessToken) async {
    try {
      return await http
          .get(getBackendAddress(kFriends), headers: {
            "authorization": "Bearer $accessToken",
          })
          .timeout(requestTimeout)
          .then((response) async {
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
              Failure("Failed to get friends."),
            );
          });
    } catch (err) {
      return Right(
        Failure("Failed to connect to the network."),
      );
    }
  }
}

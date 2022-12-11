import 'dart:convert';
import 'package:dartz/dartz.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../../services/services.dart';
import '../interfaces/interfaces.dart';

class DirectConversationRepository implements IDirectConversationRepository {
  @override
  Future<
      Either<List<Tuple2<DirectConversationEntity, DirectMessageEntity>>,
          Failure>> getRecents(String accessToken) => restService
      .get(
        kRecentDirectConvos,
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
                        (result) => Tuple2(
                          DirectConversationEntity.fromJson(
                              result['conversation']),
                          DirectMessageEntity.fromJson(
                            result['message'],
                          ),
                        ),
                      )
                      .toList(),
                );
              }
            }
            return Right(
              Failure("Failed to get recent conversations."),
            );
          },
          (failure) => Right(failure),
        ),
      );
}

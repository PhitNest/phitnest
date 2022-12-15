import 'dart:convert';
import 'package:dartz/dartz.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../../services/services.dart';
import '../interfaces/interfaces.dart';

class ConversationRepository implements IConversationRepository {
  @override
  Future<Either<List<Tuple2<ConversationEntity, MessageEntity>>, Failure>>
      getRecents(String accessToken) => restService
          .get(
            kRecentConvos,
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
                              ConversationEntity.fromJson(
                                result['conversation'],
                              ),
                              MessageEntity.fromJson(
                                result['message'],
                              ),
                            ),
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
}

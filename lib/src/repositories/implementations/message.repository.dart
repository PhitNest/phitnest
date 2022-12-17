import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../../services/services.dart';
import '../repositories.dart';

class MessageRepository implements IMessageRepository {
  @override
  Future<Either<List<MessageEntity>, Failure>> getMessages(
    String accessToken,
    String conversationId,
  ) =>
      restService.get(
        kGetMessages,
        accessToken: accessToken,
        params: {
          "conversationId": conversationId,
        },
      ).then(
        (either) => either.fold(
          (response) {
            if (response.statusCode == kStatusOK) {
              final json = jsonDecode(response.body);
              if (json is List) {
                return Left(
                  json
                      .map(
                        (result) => MessageEntity.fromJson(result),
                      )
                      .toList(),
                );
              }
            }
            return Right(
              Failure(
                jsonDecode(response.body).toString(),
              ),
            );
          },
          (failure) => Right(failure),
        ),
      );
}

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

  @override
  Future<Either<Stream<MessageEntity>, Failure>> messageStream(
    String accessToken,
  ) async =>
      (await eventService.stream(kMessage, accessToken)).leftMap(
        (stream) => stream.map(
          (event) => MessageEntity.fromJson(event),
        ),
      );

  @override
  Future<Either<Stream<Tuple2<ConversationEntity, MessageEntity>>, Failure>>
      directMessageStream(
    String accessToken,
  ) async =>
          (await eventService.stream(kDirectMessage, accessToken)).leftMap(
            (stream) => stream.map(
              (json) => Tuple2(
                ConversationEntity.fromJson(json['conversation']),
                MessageEntity.fromJson(json['message']),
              ),
            ),
          );

  @override
  Future<Either<Tuple2<ConversationEntity, MessageEntity>, Failure>>
      sendDirectMessage(
    String accessToken,
    String recipientCognitoId,
    String text,
  ) async =>
          (await eventService.emit(
            kDirectMessage,
            {
              "recipientId": recipientCognitoId,
              "text": text,
            },
            accessToken,
          ))
              .fold(
            (json) => Left(
              Tuple2(
                ConversationEntity.fromJson(json['conversation']),
                MessageEntity.fromJson(json['message']),
              ),
            ),
            (failure) => Right(failure),
          );

  @override
  Future<Either<MessageEntity, Failure>> sendMessage(
          String accessToken, String conversationId, String text) async =>
      (await eventService.emit(
        kMessage,
        {
          "conversationId": conversationId,
          "text": text,
        },
        accessToken,
      ))
          .leftMap(
        (json) => MessageEntity.fromJson(json),
      );
}

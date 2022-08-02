import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../constants/constants.dart';
import 'auth_api.dart';

class DatabaseApi {
  static DatabaseApi instance = DatabaseApi();

  /// Get the signed in users full info from the database
  Future<AuthenticatedUser> getUserInfo() => http
          .get(Uri.parse('$kBackEndUrl/user/fullData'),
              headers: AuthApi.instance.requestHeaders)
          .then((res) {
        if (res.statusCode == 200) {
          return AuthenticatedUser.fromJson(jsonDecode(res.body));
        } else {
          throw HttpException(res.body);
        }
      });

  Future<List<MapEntry<Conversation, ChatMessage>>> getRecentConversations() =>
      http
          .get(Uri.parse('$kBackEndUrl/conversation/listRecents'),
              headers: AuthApi.instance.requestHeaders)
          .then((res) {
        if (res.statusCode == 200) {
          List<dynamic> json = jsonDecode(res.body);
          return json
              .map((convoMessage) => MapEntry(
                  Conversation.fromJson(convoMessage['conversation']!),
                  ChatMessage.fromJson(convoMessage['message']!)))
              .toList();
        } else {
          throw HttpException(res.body);
        }
      });

  /// Gets messages from a conversation
  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    int limit = 10,
  }) =>
      http
          .get(
        Uri.parse(
            '$kBackEndUrl/message/list?conversation=$conversationId&limit=$limit'),
        headers: AuthApi.instance.requestHeaders,
      )
          .then((res) {
        if (res.statusCode == 200) {
          List<dynamic> json = jsonDecode(res.body);
          return json.map((message) => ChatMessage.fromJson(message)).toList();
        } else {
          throw HttpException(res.body);
        }
      });
}

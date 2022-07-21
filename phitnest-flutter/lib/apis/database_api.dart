import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../constants/constants.dart';
import 'auth_api.dart';

class DatabaseApi {
  static DatabaseApi instance = DatabaseApi();

  /// Get a users public info from the database
  Future<UserPublicInfo> getPublicInfo(String uid) => http
          .get(Uri.parse('$kBackEndUrl/user/publicData?id=$uid'),
              headers: AuthApi.instance.requestHeaders)
          .then((res) {
        if (res.statusCode == 200) {
          return UserPublicInfo.fromJson(jsonDecode(res.body));
        } else {
          throw HttpException(res.body);
        }
      });

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

  /// Get the signed in users conversations
  Future<List<Conversation>> getConversations({int limit = 10}) => http
          .get(Uri.parse('$kBackEndUrl/conversation/list?limit=$limit'),
              headers: AuthApi.instance.requestHeaders)
          .then((res) {
        if (res.statusCode == 200) {
          List<dynamic> json = jsonDecode(res.body);
          return json
              .map((conversation) => Conversation.fromJson(conversation))
              .toList();
        } else {
          throw HttpException(res.body);
        }
      });

  Future<List<MapEntry<Conversation, ChatMessage>>> getRecentConversations() =>
      http
          .get(Uri.parse('$kBackEndUrl/conversation/recents'),
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

  /// Updates the signed in users public info
  Future<void> updatePublicInfo(
          {bool? online, String? bio, String? firstName, String? lastName}) =>
      http.patch(Uri.parse('$kBackEndUrl/user/publicData'),
          headers: AuthApi.instance.requestHeaders,
          body: {
            ...(online != null ? {'online': online} : {}),
            ...(bio != null ? {'bio': bio} : {}),
            ...(firstName != null ? {'firstName': firstName} : {}),
            ...(lastName != null ? {'lastName': lastName} : {}),
          }).then((res) {
        if (res.statusCode != 200) {
          throw HttpException(res.body);
        }
      });

  /// Create a conversation with another user
  Future<String> createConversation(String otherUser) =>
      http.post(Uri.parse('$kBackEndUrl/conversation/create'),
          headers: AuthApi.instance.requestHeaders,
          body: {'otherUser': otherUser}).then((res) {
        if (res.statusCode == 200) {
          return jsonDecode(res.body)['id'];
        } else {
          throw HttpException(res.body);
        }
      });

  /// Gets messages from a conversation
  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    bool descending = true,
    int limit = 10,
  }) =>
      http
          .get(
        Uri.parse(
            '$kBackEndUrl/message/list?conversation=$conversationId&descending=$descending&limit=$limit'),
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

  /// Send a chat message to a conversation
  Future<String> sendMessage(String conversationId, String message) =>
      http.post(Uri.parse('$kBackEndUrl/message/send'),
          headers: AuthApi.instance.requestHeaders,
          body: {
            'conversation': conversationId,
            'message': message,
          }).then((res) {
        if (res.statusCode == 200) {
          return jsonDecode(res.body)['id'];
        } else {
          throw HttpException(res.body);
        }
      });
}

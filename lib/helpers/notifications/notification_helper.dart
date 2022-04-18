import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:phitnest/constants/constants.dart';
import 'package:phitnest/models/models.dart';
import 'package:phitnest/screens/screens.dart';

class NotificationUtils {
  static sendNotification(String token, String title, String body,
      Map<String, dynamic>? payload) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$SERVER_KEY',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': payload ?? <String, dynamic>{},
          'to': token
        },
      ),
    );
  }

  static void handleNotification(
      Map<String, dynamic> message, GlobalKey<NavigatorState> navigatorKey) {
    /// right now we only handle click actions on chat messages only
    try {
      if (message.containsKey('members') &&
          message.containsKey('isGroup') &&
          message.containsKey('conversationModel')) {
        List<User> members = List<User>.from(
            (jsonDecode(message['members']) as List<dynamic>)
                .map((e) => User.fromPayload(e))).toList();
        bool isGroup = jsonDecode(message['isGroup']);
        ConversationModel conversationModel = ConversationModel.fromPayload(
            jsonDecode(message['conversationModel']));
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              homeConversationModel: HomeConversationModel(
                members: members,
                isGroupChat: isGroup,
                conversationModel: conversationModel,
              ),
            ),
          ),
        );
      }
    } catch (e, s) {
      print('MyAppState._handleNotification $e $s');
    }
  }

  /// this faction is called when the notification is clicked from system tray
  /// when the app is in the background or completely killed

  static Future<dynamic> backgroundMessageHandler(
      RemoteMessage remoteMessage) async {
    await Firebase.initializeApp();
    Map<dynamic, dynamic> message = remoteMessage.data;
    if (message.containsKey('data')) {
      // Handle data message
      print('backgroundMessageHandler message.containsKey(data)');
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print('backgroundMessageHandler message.containsKey(notification)');
    }
  }
}

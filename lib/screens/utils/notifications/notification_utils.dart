import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../screens.dart';

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

  static initializeNotifications(GlobalKey<NavigatorState> key) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    _handleNotification(initialMessage, key);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      return _handleNotification(message, key);
    });

    if (!Platform.isIOS) {
      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    }
  }

  /// this faction is called when the notification is clicked from system tray
  /// when the app is in the background or completely killed
  static Future<dynamic> _backgroundMessageHandler(
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

  static void _handleNotification(
      RemoteMessage? message, GlobalKey<NavigatorState> navigatorKey) {
    /// right now we only handle click actions on chat messages only
    if (message != null) {
      Map<String, dynamic> data = message.data;
      try {
        if (data.containsKey('members') &&
            data.containsKey('isGroup') &&
            data.containsKey('conversationModel')) {
          List<UserModel> members = List<UserModel>.from(
              (jsonDecode(data['members']) as List<dynamic>)
                  .map((e) => UserModel.fromPayload(e))).toList();
          bool isGroup = jsonDecode(data['isGroup']);
          ConversationModel conversationModel = ConversationModel.fromPayload(
              jsonDecode(data['conversationModel']));
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                user: Provider.of<BackEndModel>(navigatorKey.currentContext!,
                        listen: false)
                    .currentUser!,
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
  }
}

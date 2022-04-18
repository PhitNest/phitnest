export 'package:phitnest/helpers/dialog/dialog_helper.dart';
export 'package:phitnest/helpers/time/time_helper.dart';
export 'package:phitnest/helpers/display/display_helper.dart';
export 'package:phitnest/helpers/firebase/firebase_helper.dart';
export 'package:phitnest/helpers/authentication/authentication_helper.dart';
export 'package:phitnest/helpers/location/location_helper.dart';
export 'package:phitnest/helpers/helper.dart';
export 'package:phitnest/helpers/navigation/navigation_helper.dart';

import 'dart:convert';

import 'package:phitnest/constants/constants.dart';
import 'package:http/http.dart' as http;

sendNotification(String token, String title, String body,
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

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Image?> getProfilePicture(Session session, String identityId) async {
  final uri = getProfilePictureUri(session, identityId);
  try {
    final res = await http.get(uri.uri, headers: uri.headers);
    if (res.statusCode == 200) {
      return Image.memory(res.bodyBytes);
    } else {
      error('Failed to get profile picture', details: [
        'Status code: ${res.statusCode}',
        'Response body: ${res.body}',
      ]);
      return null;
    }
  } catch (e) {
    error(e.toString());
    return null;
  }
}

import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;

import '../../config/aws.dart';
import '../logger.dart';
import 'aws.dart';

const s3Endpoint = 'https://$kUserBucketName.s3.$kRegion.amazonaws.com';

({Uri uri, Map<String, String> headers}) getProfilePictureUri(
    Session session, String identityId) {
  final String bucketKey = 'profilePictures/$identityId';
  final uri = Uri.parse(s3Endpoint);
  final accessKeyId = session.credentials.accessKeyId!;
  final datetime = SigV4.generateDatetime();
  final expiration = (DateTime.now())
      .add(Duration(minutes: 15))
      .toUtc()
      .toString()
      .split(' ')
      .join('T');
  final cred =
      '$accessKeyId/${SigV4.buildCredentialScope(datetime, 'us-east-1', 's3')}';
  final key = SigV4.calculateSigningKey(
    session.credentials.secretAccessKey!,
    datetime,
    kRegion,
    's3',
  );
  final policy = base64.encode(utf8.encode('''{ 
  "expiration": "$expiration",
  "conditions": [
    {"bucket": "$kUserBucketName"},
    ["starts-with", "\$key", "$bucketKey"],
    {"x-amz-credential": "$cred"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "$datetime" },
    {"x-amz-security-token": "${session.credentials.sessionToken!}" }
  ]
}'''));
  final signature = SigV4.calculateSignature(key, policy);
  final headers = {
    'key': bucketKey,
    'X-Amz-Credential': cred,
    'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
    'X-Amz-Date': datetime,
    'Policy': policy,
    'X-Amz-Signature': signature,
    'x-amz-security-token': session.credentials.sessionToken!,
  };
  return (uri: uri, headers: headers);
}

Future<String?> uploadProfilePicture({
  required http.ByteStream photo,
  required int length,
  required Session session,
  required String identityId,
}) async {
  try {
    final String bucketKey = 'profilePictures/$identityId';
    final uri = Uri.parse(s3Endpoint);
    final req = http.MultipartRequest('POST', uri);
    final multipartFile = http.MultipartFile(
      'file',
      photo,
      length,
    );
    final accessKeyId = session.credentials.accessKeyId!;
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: 15))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');
    final cred =
        '$accessKeyId/${SigV4.buildCredentialScope(datetime, 'us-east-1', 's3')}';
    final key = SigV4.calculateSigningKey(
      session.credentials.secretAccessKey!,
      datetime,
      kRegion,
      's3',
    );

    final policy = base64.encode(utf8.encode('''{ 
  "expiration": "$expiration",
  "conditions": [
    {"bucket": "$kUserBucketName"},
    ["starts-with", "\$key", "$bucketKey"],
    ["content-length-range", 1, $length],
    {"x-amz-credential": "$cred"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "$datetime" },
    {"x-amz-security-token": "${session.credentials.sessionToken!}" }
  ]
}'''));

    final signature = SigV4.calculateSignature(key, policy);

    req.files.add(multipartFile);
    req.fields['key'] = bucketKey;
    req.fields['X-Amz-Credential'] = cred;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = datetime;
    req.fields['Policy'] = policy;
    req.fields['X-Amz-Signature'] = signature;
    req.fields['x-amz-security-token'] = session.credentials.sessionToken!;

    final res = await req.send();
    await for (String value in res.stream.transform(utf8.decoder)) {
      debug(value);
    }
    return null;
  } catch (e) {
    error(
      'Error thrown while uploading picture',
      details: [
        'Identity ID: $identityId',
        'Error: ${e.toString()}',
      ],
    );
    return e.toString();
  }
}

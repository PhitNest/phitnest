import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;

import '../../config/aws.dart';
import '../logger.dart';
import 'aws.dart';

const kS3Service = 's3';

({Uri uri, Map<String, String> headers}) getProfilePictureUri(
    Session session, String identityId) {
  final key = '$kUserBucketName/profilePicture/$identityId';
  final payload = SigV4.hashCanonicalRequest('');
  final datetime = SigV4.generateDatetime();
  final host = '$kS3Service.$kRegion.amazonaws.com';
  final canonicalRequest = '''GET
${'/$key'.split('/').map((s) => Uri.encodeComponent(s)).join('/')}

host:$host
x-amz-content-sha256:$payload
x-amz-date:$datetime
x-amz-security-token:${session.credentials.sessionToken}

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
$payload''';
  final credentialScope =
      SigV4.buildCredentialScope(datetime, kRegion, kS3Service);
  final stringToSign = SigV4.buildStringToSign(
      datetime, credentialScope, SigV4.hashCanonicalRequest(canonicalRequest));
  final signingKey = SigV4.calculateSigningKey(
      session.credentials.secretAccessKey!, datetime, kRegion, kS3Service);
  final signature = SigV4.calculateSignature(signingKey, stringToSign);

  final authorization = [
    'AWS4-HMAC-SHA256 Credential=${session.credentials.accessKeyId}/$credentialScope',
    'SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token',
    'Signature=$signature',
  ].join(',');

  final uri = Uri.https(host, key);

  return (
    uri: uri,
    headers: {
      'Authorization': authorization,
      'x-amz-content-sha256': payload,
      'x-amz-date': datetime,
      'x-amz-security-token': session.credentials.sessionToken!,
    }
  );
}

Future<String?> uploadProfilePicture({
  required http.ByteStream photo,
  required int length,
  required Session session,
  required String identityId,
}) async {
  try {
    final s3Endpoint =
        'https://$kUserBucketName.$kS3Service.$kRegion.amazonaws.com';
    final String bucketKey = 'profilePicture/$identityId';
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

part of 'cognito.dart';

const kS3Service = 's3';

({Uri uri, Map<String, String> headers}) getProfilePictureUri(
  Session session,
  String identityId,
) {
  final key =
      '${session.apiInfo.userBucketName}/profilePictures/$identityId.txt';
  final payload = SigV4.hashCanonicalRequest('');
  final datetime = SigV4.generateDatetime();
  final region = session.user.pool.getRegion()!;
  final host = '$kS3Service.$region.amazonaws.com';
  final canonicalRequest = '''GET
${'/$key'.split('/').map((s) => Uri.encodeComponent(s)).join('/')}

host:$host
x-amz-content-sha256:$payload
x-amz-date:$datetime
x-amz-security-token:${session.credentials.sessionToken}

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
$payload''';
  final credentialScope =
      SigV4.buildCredentialScope(datetime, region, kS3Service);
  final stringToSign = SigV4.buildStringToSign(
      datetime, credentialScope, SigV4.hashCanonicalRequest(canonicalRequest));
  final signingKey = SigV4.calculateSigningKey(
      session.credentials.secretAccessKey!, datetime, region, kS3Service);
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

Future<Failure?> uploadProfilePicture({
  required http.ByteStream photo,
  required int length,
  required Session session,
}) async {
  try {
    final region = session.user.pool.getRegion()!;
    final s3Endpoint =
        'https://${session.apiInfo.userBucketName}.$kS3Service.$region.amazonaws.com';
    final String? userId = session.credentials.userIdentityId;
    if (userId == null) {
      return Failure('FailedToUpload', 'User is not logged in');
    }
    final String bucketKey = 'profilePictures/$userId.txt';
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
      session.user.pool.getRegion()!,
      's3',
    );

    final policy = base64.encode(utf8.encode('''
{ "expiration": "$expiration",
  "conditions": [
    {"bucket": "${session.apiInfo.userBucketName}"},
    ["starts-with", "\$key", "$bucketKey"],
    ["content-length-range", 1, $length],
    {"x-amz-credential": "$cred"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "$datetime" },
    {"x-amz-security-token": "${session.credentials.sessionToken!}" }
  ]
}
'''));

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
    await for (var value in res.stream.transform(utf8.decoder)) {
      prettyLogger.d(value);
    }
    return null;
  } catch (e) {
    prettyLogger.e(
      'Error thrown while uploading pfp\n'
      'Identity ID: ${session.credentials.userIdentityId}\n'
      'Error: ${e.toString()}',
    );
    return Failure('FailedToUpload', e.toString());
  }
}

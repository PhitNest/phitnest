part of 'cognito.dart';

({Uri uri, Map<String, String> headers})? getProfilePicture(Session session) {
  try {
    const host = 's3.us-east-1.amazonaws.com';
    const region = 'us-east-1';
    const service = 's3';
    final key =
        '${session.userBucketName}/profilePictures/${session.session.accessToken.getSub()}.txt';
    final payload = SigV4.hashCanonicalRequest('');
    final datetime = SigV4.generateDatetime();
    final canonicalRequest = '''GET
${'/$key'.split('/').map((s) => Uri.encodeComponent(s)).join('/')}

host:$host
x-amz-content-sha256:$payload
x-amz-date:$datetime
x-amz-security-token:${session.credentials.sessionToken}

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
$payload''';
    final credentialScope =
        SigV4.buildCredentialScope(datetime, region, service);
    final stringToSign = SigV4.buildStringToSign(datetime, credentialScope,
        SigV4.hashCanonicalRequest(canonicalRequest));
    final signingKey = SigV4.calculateSigningKey(
        session.credentials.secretAccessKey!, datetime, region, service);
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
  } catch (e) {
    return null;
  }
}

class Policy {
  String expiration;
  String bucket;
  String key;
  String credential;
  String datetime;
  String sessionToken;
  int maxFileSize;

  Policy(
    this.key,
    this.bucket,
    this.datetime,
    this.expiration,
    this.credential,
    this.maxFileSize,
    this.sessionToken,
  );

  factory Policy.fromS3PresignedPost(
    String key,
    String bucket,
    int expiryMinutes,
    String accessKeyId,
    int maxFileSize,
    String sessionToken,
  ) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: expiryMinutes))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');
    final cred =
        '$accessKeyId/${SigV4.buildCredentialScope(datetime, 'us-east-1', 's3')}';
    final p = Policy(
      key,
      bucket,
      datetime,
      expiration,
      cred,
      maxFileSize,
      sessionToken,
    );
    return p;
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
    { "expiration": "$expiration",
      "conditions": [
        {"bucket": "$bucket"},
        ["starts-with", "\$key", "$key"],
        ["content-length-range", 1, $maxFileSize],
        {"content-type": "multipart/form-data"}
        {"x-amz-credential": "$credential"},
        {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
        {"x-amz-date": "$datetime" },
        {"x-amz-security-token": "$sessionToken" }
      ]
    }
    ''';
  }
}

Future<Failure?> uploadProfilePicture({
  required http.ByteStream photo,
  required int length,
  required String fileType,
  required Session session,
}) async {
  final region = session.user.pool.getRegion();
  final s3Endpoint =
      'https://${session.userBucketName}.s3.$region.amazonaws.com';

  final String bucketKey =
      'profilePictures/${session.session.getAccessToken().getSub()}.txt';

  final uri = Uri.parse(s3Endpoint);
  final req = http.MultipartRequest('POST', uri);
  final multipartFile = http.MultipartFile(
    'file',
    photo,
    length,
  );

  final policy = Policy.fromS3PresignedPost(
    bucketKey,
    session.userBucketName,
    15,
    session.credentials.accessKeyId!,
    length,
    session.credentials.sessionToken!,
  );
  final key = SigV4.calculateSigningKey(
    session.credentials.secretAccessKey!,
    policy.datetime,
    session.user.pool.getRegion()!,
    's3',
  );
  final signature = SigV4.calculateSignature(key, policy.encode());

  req.files.add(multipartFile);
  req.fields['key'] = policy.key;
  req.fields['X-Amz-Credential'] = policy.credential;
  req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
  req.fields['X-Amz-Date'] = policy.datetime;
  req.fields['Policy'] = policy.encode();
  req.fields['X-Amz-Signature'] = signature;
  req.fields['x-amz-security-token'] = session.credentials.sessionToken!;

  try {
    final res = await req.send();
    await res.stream.last;
    return null;
  } catch (e) {
    print(e.toString());
    return Failure('FailedToUpload', e.toString());
  }
}

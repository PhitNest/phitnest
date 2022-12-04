import 'authentication_failure.dart';

export 'authentication_failure.dart';

abstract class Failure {
  const Failure();

  factory Failure.fromResponse(int statusCode, Map<String, dynamic> body) {
    if (statusCode == 500) {
      if (body['message'] == 'You are not authenticated') {
        return AuthenticationFailure();
      }
    }
    throw new Error();
  }
}

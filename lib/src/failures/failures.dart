export 'cache.failure.dart';
export 'location.failure.dart';

abstract class Failure {
  const Failure();

  factory Failure.fromResponse(int statusCode, Map<String, dynamic> body) {
    throw new Error();
  }
}

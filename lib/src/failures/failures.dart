export 'cache.failure.dart';
export 'location.failure.dart';

abstract class Failure {
  final String message;

  const Failure({
    required this.message,
  });

  factory Failure.fromResponse(int statusCode, Map<String, dynamic> body) {
    throw new Error();
  }
}

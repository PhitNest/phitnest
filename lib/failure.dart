Failure invalidJson(dynamic data) =>
    Failure('InvalidFailure', 'Invalid Failure JSON: $data');

final class Failure {
  final String type;
  final String message;

  const Failure(this.type, this.message);

  @override
  String toString() => message;

  factory Failure.fromJson(dynamic json) => switch (json) {
        {'type': final String type, 'message': final String message} =>
          Failure(type, message),
        _ => invalidJson(json),
      };
}

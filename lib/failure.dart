invalidFailure(dynamic data) => Failure("Invalid Failure JSON: $data");

class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;

  factory Failure.fromJson(dynamic json) => switch (json) {
        {"message": String message} => Failure(message),
        _ => invalidFailure(json),
      };
}

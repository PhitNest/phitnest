class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;

  factory Failure.fromJson(Map<String, Object?> json) =>
      Failure(json['message'] as String);
}

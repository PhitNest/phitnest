class Failure {
  final String code;
  final String message;
  final dynamic details;

  const Failure(this.code, this.message, {this.details});

  factory Failure.fromJson(Map<String, dynamic> json) => Failure(
        json['code'],
        json['message'],
        details: json['details'],
      );
}

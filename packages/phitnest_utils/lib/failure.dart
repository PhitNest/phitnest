import 'package:phitnest_utils/serializable.dart';

class Failure with Serializable {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;

  @override
  Map<String, Object?> toJson() => {
        'message': message,
      };

  factory Failure.fromJson(Map<String, Object?> json) =>
      Failure(json['message'] as String);
}

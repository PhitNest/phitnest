import 'package:equatable/equatable.dart';

Failure invalidFailure(dynamic data) =>
    Failure('InvalidFailure', 'Invalid JSON for root of Failure: $data');

final class Failure extends Equatable {
  final String type;
  final String message;

  const Failure(this.type, this.message);

  @override
  String toString() => message;

  factory Failure.fromJson(dynamic json) => switch (json) {
        {'type': final String type, 'message': final String message} =>
          Failure(type, message),
        _ => invalidFailure(json),
      };

  @override
  List<Object?> get props => [type, message];
}

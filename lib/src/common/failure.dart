import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String code;
  final String message;
  final dynamic details;

  const Failure(this.code, this.message, {this.details});

  factory Failure.fromJson(Map<String, dynamic> json) => Failure(
        json['code'],
        json['message'],
        details: json['details'],
      );

  @override
  List<Object?> get props => [code, message, details];
}

const kNetworkFailure =
    Failure("NetworkFailure", "Failed to connect to the network.");

const kInvalidBackendResponse = Failure(
  "InvalidBackendResponse",
  "The backend returned an invalid response.",
);

import 'package:equatable/equatable.dart';

enum FailureType {
  network("Could not reach network."),
  location_permission_denied("Location permissions are denied."),
  location_permission_permanently_denied(
      "Location permissions are permanently denied."),
  cache("Cache missed."),
  login("Invalid username or password."),
  invalid_email("Invalid email."),
  gym_not_found("Gym could not be found."),
  unknown("Unknown error.");

  final String message;

  const FailureType(this.message);
}

class Failure extends Equatable {
  final FailureType type;

  String get message => type.message;

  const Failure({
    required this.type,
  }) : super();

  @override
  List<Object?> get props => [type];
}

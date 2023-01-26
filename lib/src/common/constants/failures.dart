import '../failure.dart';

enum Failures {
  networkFailure,
  invalidBackendResponse,
  locationFailure,
  locationPermanentlyDeniedFailure,
  userNotConfirmed,
  noGymsFound,
  failedToCropImage,
  invalidCode,
}

extension Instance on Failures {
  Failure get instance {
    switch (this) {
      case Failures.invalidCode:
        return const Failure("InvalidCode", "Invalid code.");
      case Failures.networkFailure:
        return const Failure(
            "NetworkFailure", "Failed to connect to the network.");
      case Failures.invalidBackendResponse:
        return const Failure(
          "InvalidBackendResponse",
          "The backend returned an invalid response.",
        );
      case Failures.locationFailure:
        return const Failure(
            "LocationDenied", "Location permissions are denied.");
      case Failures.locationPermanentlyDeniedFailure:
        return const Failure("LocationPermanentlyDenied",
            "Location permissions are permanently denied, we cannot request permissions.");
      case Failures.userNotConfirmed:
        return const Failure(
            "UserNotConfirmedException", "User is not confirmed.");
      case Failures.noGymsFound:
        return const Failure("NoGymsFound", "No nearby gyms found.");
      case Failures.failedToCropImage:
        return const Failure("FailedToCropImage", "Failed to crop image.");
    }
  }
}

extension Code on Failures {
  String get code => instance.code;
}

extension Message on Failures {
  String get message => instance.message;
}

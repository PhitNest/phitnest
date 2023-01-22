import 'failure.dart';

const kNetworkFailure =
    Failure("NetworkFailure", "Failed to connect to the network.");

const kInvalidBackendResponse = Failure(
  "InvalidBackendResponse",
  "The backend returned an invalid response.",
);

final kLocationFailure =
    Failure("LocationDenied", "Location permissions are denied.");

final kLocationPermanentlyDeniedFailure = Failure("LocationPermanentlyDenied",
    "Location permissions are permanently denied, we cannot request permissions.");

final kUserNotConfirmed =
    Failure("UserNotConfirmedException", "User is not confirmed.");

final kNoGymsFound = Failure("NoGymsFound", "No nearby gyms found.");

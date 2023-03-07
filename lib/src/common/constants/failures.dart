import 'package:phitnest_utils/failure.dart';
import 'package:phitnest_utils/http_adapter.dart';

enum Failures {
  networkConnectionFailure,
}

extension Data on Failures {
  Failure get instance {
    switch (this) {
      case Failures.networkConnectionFailure:
        return kNetworkConnectionFailure;
    }
  }

  String get code => instance.name;
  String get message => instance.message;
}

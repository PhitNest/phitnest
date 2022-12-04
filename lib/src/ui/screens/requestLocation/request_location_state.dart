import '../state.dart';

import 'request_location_provider.dart';
import 'request_location_view.dart';

/// Holds the dynamic content of [RequestLocationProvider]. Calls to [rebuild] will rebuild
/// the [RequestLocationView].
class RequestLocationState extends ScreenState {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }
}

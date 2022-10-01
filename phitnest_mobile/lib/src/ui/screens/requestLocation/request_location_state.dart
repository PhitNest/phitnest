import '../state.dart';

import 'request_location_screen.dart';
import 'request_location_view.dart';

/**
 * Holds the dynamic content of [RequestLocationScreen]. Calls to [rebuildView] will rebuild 
 * the [RequestLocationView].
 */
class RequestLocationState extends ScreenState {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    rebuildView();
  }
}

import '../state.dart';

class RequestLocationState extends ScreenState {
  bool _searching = false;

  bool get searching => _searching;

  set searching(bool searching) {
    _searching = searching;
    rebuildView();
  }

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    rebuildView();
  }
}

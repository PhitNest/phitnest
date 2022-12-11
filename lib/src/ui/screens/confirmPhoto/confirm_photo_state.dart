import '../state.dart';

class ConfirmPhotoState extends ScreenState {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? value) {
    _errorMessage = value;
    rebuildView();
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    rebuildView();
  }
}

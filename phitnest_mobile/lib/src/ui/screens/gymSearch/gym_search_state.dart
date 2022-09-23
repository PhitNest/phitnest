import '../../../models/models.dart';
import '../state.dart';

class GymSearchState extends ScreenState {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  List<Gym> _gyms = [];

  List<Gym> get gyms => _gyms;

  set gyms(List<Gym> gyms) {
    _gyms = gyms;
    notifyListeners();
  }
}

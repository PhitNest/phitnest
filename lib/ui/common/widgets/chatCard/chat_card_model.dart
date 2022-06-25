import '../../../base_model.dart';

class ChatCardModel extends BaseModel {
  bool _selected = false;

  bool get selected => _selected;

  set selected(bool selected) {
    _selected = selected;
    notifyListeners();
  }
}

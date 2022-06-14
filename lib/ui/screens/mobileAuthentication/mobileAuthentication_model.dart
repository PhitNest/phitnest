import 'package:flutter/cupertino.dart';
import 'package:phitnest/ui/screens/base/base_model.dart';

class MobileAuthenticationModel extends BaseModel {
  /// Controls the phone number field
  final phoneNumberController = TextEditingController();

  /// Validation mode
  AutovalidateMode _validate = AutovalidateMode.disabled;

  GlobalKey<FormState> formKey = GlobalKey();

  AutovalidateMode get validate => _validate;

  bool _sent = false;

  bool get sent => _sent;

  set sent(bool sent) {
    _sent = sent;
    notifyListeners();
  }

  /// This will rebuild the view
  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:phitnest/ui/screens/base/base_model.dart';

class ForgotPasswordModel extends BaseModel {
  /// Controls the email field
  final emailController = TextEditingController();

  /// Validation mode
  AutovalidateMode _validate = AutovalidateMode.disabled;

  AutovalidateMode get validate => _validate;

  /// This will rebuild the view
  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }
}

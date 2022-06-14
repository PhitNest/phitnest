import 'package:flutter/cupertino.dart';
import 'package:phitnest/ui/screens/base/base_model.dart';

class ForgotPasswordModel extends BaseModel {
  /// Controls the email field
  final emailController = TextEditingController();

  /// Form key
  final GlobalKey<FormState> formKey = GlobalKey();

  bool _sent = false;

  bool get sent => _sent;

  // Rebuild the view after sending
  set sent(bool sent) {
    _sent = sent;
    notifyListeners();
  }

  /// Validation mode
  AutovalidateMode _validate = AutovalidateMode.disabled;

  AutovalidateMode get validate => _validate;

  /// This will rebuild the view
  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }
}

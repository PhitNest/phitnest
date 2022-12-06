import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../state.dart';

class LoginState extends ScreenState {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late final FocusNode focusPassword = FocusNode()
    ..addListener(() => onFocusEmail(focusEmail.hasFocus));
  late final FocusNode focusEmail = FocusNode()
    ..addListener(() => onFocusPassword(focusPassword.hasFocus));

  void onFocusEmail(bool focused) {
    if (focused) {
      scrollController.animateTo(
        20.h,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void onFocusPassword(bool focused) {
    if (focused) {
      scrollController.animateTo(
        40.h,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  AutovalidateMode _validateMode = AutovalidateMode.disabled;

  AutovalidateMode get validateMode => _validateMode;

  set validateMode(AutovalidateMode validateMode) {
    _validateMode = validateMode;
    rebuildView();
  }

  @override
  void dispose() {
    focusEmail.dispose();
    focusPassword.dispose();
    scrollController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

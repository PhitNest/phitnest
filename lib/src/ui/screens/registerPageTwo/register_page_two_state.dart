import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../state.dart';

class RegisterPageTwoState extends ScreenState {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late final FocusNode emailFocus = FocusNode()
    ..addListener(() => onFocusEmail(emailFocus.hasFocus));
  late final FocusNode passwordFocus = FocusNode()
    ..addListener(() => onFocusPassword(passwordFocus.hasFocus));
  late final FocusNode confirmPasswordFocus = FocusNode()
    ..addListener(() => onFocusConfirmPassword(confirmPasswordFocus.hasFocus));
  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

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

  void onFocusConfirmPassword(bool focused) {
    if (focused) {
      scrollController.animateTo(
        60.h,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  AutovalidateMode get autovalidateMode => _autovalidateMode;

  set autovalidateMode(AutovalidateMode autovalidateMode) {
    _autovalidateMode = autovalidateMode;
    rebuildView();
  }

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    rebuildView();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../state.dart';

class ForgotPasswordState extends ScreenState {
  final emailAddressController = TextEditingController();
  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  late final FocusNode emailFocus = FocusNode()
    ..addListener(() => onFocusEmail(emailFocus.hasFocus));

  void onFocusEmail(bool focused) {
    if (focused) {
      scrollController.animateTo(
        70.h,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? message) {
    _errorMessage = message;
    rebuildView();
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    rebuildView();
  }

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  AutovalidateMode get autovalidateMode => _autovalidateMode;

  set autovalidateMode(AutovalidateMode mode) {
    _autovalidateMode = mode;
    rebuildView();
  }

  @override
  void dispose() {
    emailAddressController.dispose();
    scrollController.dispose();
    emailFocus.dispose();
    super.dispose();
  }
}

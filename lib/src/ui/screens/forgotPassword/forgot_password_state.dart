import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../state.dart';

class ForgotPasswordState extends ScreenState {
  final emailAddressController = TextEditingController();
  final scrollController = ScrollController();
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

  @override
  void dispose() {
    emailAddressController.dispose();
    scrollController.dispose();
    emailFocus.dispose();
    super.dispose();
  }
}

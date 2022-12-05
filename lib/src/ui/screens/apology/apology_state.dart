import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../state.dart';

class ApologyState extends ScreenState {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  late final FocusNode nameFocusNode = FocusNode()
    ..addListener(() => onFocusName(nameFocusNode.hasFocus));
  late final FocusNode emailFocusNode = FocusNode()
    ..addListener(() => onFocusEmail(emailFocusNode.hasFocus));

  void onFocusEmail(bool focused) {
    if (focused) {
      scrollController.animateTo(
        70.h,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void onFocusName(bool focused) {
    if (focused) {
      scrollController.animateTo(
        60.h,
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
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    scrollController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

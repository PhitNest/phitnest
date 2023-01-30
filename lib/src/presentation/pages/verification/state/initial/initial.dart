import 'package:flutter/material.dart';

import '../verification_state.dart';

export 'confirming.dart';
export 'confirm_error.dart';
export 'confirm_success.dart';
export 'resend_error.dart';
export 'resending.dart';

class InitialState extends VerificationState {
  final TextEditingController codeController;
  final FocusNode codeFocusNode;

  const InitialState({
    required this.codeController,
    required this.codeFocusNode,
  }) : super();

  @override
  List<Object> get props => [codeController, codeFocusNode];
}

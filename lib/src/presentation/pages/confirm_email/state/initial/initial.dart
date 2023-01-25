import 'package:flutter/material.dart';

import '../confirm_email_state.dart';

export 'error.dart';
export 'loading.dart';

class InitialState extends ConfirmEmailState {
  final TextEditingController codeController;
  final FocusNode codeFocusNode;

  const InitialState({
    required this.codeController,
    required this.codeFocusNode,
  }) : super();

  @override
  List<Object> get props => [codeController, codeFocusNode];
}

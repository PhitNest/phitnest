import 'package:flutter/material.dart';

import '../verification.dart';

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

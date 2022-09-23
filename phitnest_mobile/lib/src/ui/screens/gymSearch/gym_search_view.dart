import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../view.dart';

class GymSearchView extends ScreenView {
  final Function() onPressedConfirm;
  final String errorMessage;

  const GymSearchView(
      {required this.onPressedConfirm, required this.errorMessage})
      : super();

  @override
  Widget build(BuildContext context) => BackButtonScaffold(body: Text('Hi'));
}

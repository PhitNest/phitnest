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
  Widget build(BuildContext context) => Scaffold(
      body: Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.12,
              bottom: MediaQuery.of(context).size.height * 0.085),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [BackArrowButton()],
          )));
}

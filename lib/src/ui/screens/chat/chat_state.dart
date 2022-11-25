import 'package:flutter/material.dart';

import '../state.dart';

class ChatState extends ScreenState {
  Color _onClickColor = Color(0xFFFFFFFF);

  get onClickColor => _onClickColor;

  set setMessageColor(Color color) {
    _onClickColor = color;
    rebuildView();
  }
}

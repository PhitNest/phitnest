import 'package:flutter/material.dart';

class BackButtonAppBar extends AppBar {
  final Color? color;
  final Widget? content;

  BackButtonAppBar({this.color, this.content})
      : super(
          leading: BackButton(
            key: Key("backButton"),
          ),
          title: content,
          elevation: 0.0,
          backgroundColor: color ?? Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
        );
}

import 'package:flutter/material.dart';

class BackButtonAppBar extends AppBar {
  BackButtonAppBar()
      : super(
          leading: BackButton(
            key: Key("backButton"),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
        );
}

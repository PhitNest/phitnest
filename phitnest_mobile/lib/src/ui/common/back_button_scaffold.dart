import 'package:flutter/material.dart';

import 'widgets.dart';

class BackButtonScaffold extends StatelessWidget {
  final Widget body;

  const BackButtonScaffold({required this.body}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
      body: body,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 68,
        toolbarHeight: 68,
        leading: Padding(
            padding: EdgeInsets.only(left: 12),
            child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: Arrow(
                  width: 40,
                  height: 12,
                  left: true,
                  color: Colors.black,
                ))),
      ));
}

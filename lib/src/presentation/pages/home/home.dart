import 'package:flutter/material.dart';

import '../../widgets/styled/styled_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Page'),
      ),
      bottomNavigationBar: StyledNavigationBar(),
    );
  }
}

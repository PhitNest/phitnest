import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../widgets/styled/styled_nav_bar.dart';

class HomePage extends StatelessWidget {
  final String initialAccessToken;
  final String initialRefreshToken;
  final UserEntity initialUserData;
  final String initialPassword;

  const HomePage({
    Key? key,
    required this.initialAccessToken,
    required this.initialRefreshToken,
    required this.initialUserData,
    required this.initialPassword,
  }) : super(key: key);

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

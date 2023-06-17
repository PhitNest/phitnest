import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../../common/util.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final String authorization;

  const HomeScreen({
    super.key,
    required this.authorization,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InviteForm(
                  authorization: authorization,
                ),
                GymEntryForm(
                  authorization: authorization,
                ),
              ],
            ),
            BlocConsumer<CognitoBloc, CognitoState>(
              listener: (context, cognitoState) {},
              builder: (context, cognitoState) => switch (cognitoState) {
                CognitoLoggingOutState() => const CircularProgressIndicator(),
                _ => TextButton(
                    onPressed: () =>
                        context.cognitoBloc.add(const CognitoLogoutEvent()),
                    child: const Text('Logout'),
                  ),
              },
            ),
          ],
        ),
      );
}

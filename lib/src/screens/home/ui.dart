import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../profile_photo/instructions/ui.dart';
import 'bloc/bloc.dart';
import 'options/ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => BlocConsumer<CognitoBloc, CognitoState>(
        listener: (context, cognitoState) {},
        builder: (context, cognitoState) => BlocProvider(
          create: (_) => HomeBloc(
            (cognitoState as CognitoLoggedInState).session,
          ),
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, screenState) {
              switch (screenState) {
                case HomeProfilePictureFailureState():
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute<void>(
                      builder: (_) => const PhotoInstructionsScreen(),
                    ),
                  );
                default:
              }
            },
            builder: (context, screenState) => Scaffold(
              body: Center(
                  child: switch (screenState) {
                HomeLoadedProfilePictureState(profilePicture: final pfp) =>
                  OptionsScreen(
                    pfp: pfp,
                  ),
                _ => Container(),
              }),
            ),
          ),
        ),
      );
}

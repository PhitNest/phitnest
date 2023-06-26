import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../profile_photo/instructions/ui.dart';
import 'bloc/bloc.dart';

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
                case HomeLoadedProfilePictureState(
                    profilePicture: final profilePicture
                  ):
                  if (profilePicture == null) {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute<void>(
                        builder: (_) => const PhotoInstructionsScreen(),
                      ),
                    );
                  }
                default:
              }
            },
            builder: (context, screenState) => Scaffold(
              body: Center(
                child: Container(),
              ),
            ),
          ),
        ),
      );
}

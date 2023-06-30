import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../../widgets/widgets.dart';
import '../profile_photo/instructions/ui.dart';
import 'bloc/bloc.dart';
import 'chat/ui.dart';
import 'explore/ui.dart';
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
                case HomeFailureState():
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
              body: switch (screenState) {
                HomeLoadedState(response: final response) => Column(
                    children: [
                      Expanded(
                        child: switch (screenState.currPage) {
                          0 => ExploreScreen(
                              users: response.explore,
                            ),
                          1 => ChatScreen(
                              friends: response.friends,
                            ),
                          _ => OptionsScreen(
                              pfp: response.profilePhoto,
                            )
                        },
                      ),
                      StyledNavBar(
                        page: screenState.currPage,
                        logoState: LogoState.animated,
                        onReleaseLogo: () {},
                        onPressDownLogo: () {},
                        onPressedNews: () {},
                        onPressedExplore: () =>
                            context.homeBloc.add(HomeTabChangedEvent(index: 0)),
                        onPressedChat: () =>
                            context.homeBloc.add(HomeTabChangedEvent(index: 1)),
                        onPressedOptions: () =>
                            context.homeBloc.add(HomeTabChangedEvent(index: 2)),
                        friendRequestCount: 0,
                      ),
                    ],
                  ),
                _ => Container(),
              },
            ),
          ),
        ),
      );
}

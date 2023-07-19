import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../../widgets/widgets.dart';
import '../login_screen.dart';

class HomeScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const HomeScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (context) => LoaderBloc<void, void>(
            load: (_) async {
              final session = await context.sessionLoader.session;
              if (session != null) {
                await logout(session: session);
              }
            },
          ),
          child: StyledNavBar(
            listener: (context, navBarState) async {},
            builder: (context, navBarState) => LoaderConsumer<void, void>(
              listener: (context, loaderState) {
                switch (loaderState) {
                  case LoaderLoadedState():
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute<void>(
                        builder: (context) => LoginScreen(apiInfo: apiInfo),
                      ),
                      (_) => false,
                    );
                  default:
                }
              },
              builder: (context, loaderState) => switch (navBarState.page) {
                NavBarPage.news => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('News screen'),
                      switch (loaderState) {
                        LoaderLoadingState() =>
                          const CircularProgressIndicator(),
                        _ => StyledOutlineButton(
                            onPress: () => context
                                .loader<void, void>()
                                .add(const LoaderLoadEvent(null)),
                            text: 'Logout',
                          ),
                      },
                    ],
                  ),
                NavBarPage.explore => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Explore screen'),
                      switch (loaderState) {
                        LoaderLoadingState() =>
                          const CircularProgressIndicator(),
                        _ => StyledOutlineButton(
                            onPress: () => context
                                .loader<void, void>()
                                .add(const LoaderLoadEvent(null)),
                            text: 'Logout',
                          ),
                      },
                    ],
                  ),
                NavBarPage.chat => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Chat screen'),
                      switch (loaderState) {
                        LoaderLoadingState() =>
                          const CircularProgressIndicator(),
                        _ => StyledOutlineButton(
                            onPress: () => context
                                .loader<void, void>()
                                .add(const LoaderLoadEvent(null)),
                            text: 'Logout',
                          ),
                      },
                    ],
                  ),
                NavBarPage.options => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Options screen'),
                      switch (loaderState) {
                        LoaderLoadingState() =>
                          const CircularProgressIndicator(),
                        _ => StyledOutlineButton(
                            onPress: () => context
                                .loader<void, void>()
                                .add(const LoaderLoadEvent(null)),
                            text: 'Logout',
                          ),
                      },
                    ],
                  ),
              },
            ),
          ),
        ),
      );
}

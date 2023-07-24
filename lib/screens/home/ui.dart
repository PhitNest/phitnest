import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../../widgets/widgets.dart';
import '../login_screen.dart';
import '../profile_photo/instructions.dart';

typedef PfpBloc = LoaderBloc<void, Image?>;
typedef PfpConsumer = LoaderConsumer<void, Image?>;
typedef LogoutBloc = LoaderBloc<void, void>;
typedef LogoutConsumer = LoaderConsumer<void, void>;

extension on BuildContext {
  PfpBloc get pfpBloc => loader();
  LogoutBloc get logoutBloc => loader();
}

class HomeScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const HomeScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LogoutBloc(
                load: (_) async {
                  final session = await context.sessionLoader.session;
                  if (session != null) {
                    await logout(session: session);
                  }
                },
              ),
            ),
            BlocProvider(
              create: (context) => PfpBloc(
                load: (_) async {
                  final session = await context.sessionLoader.session;
                  if (session != null) {
                    return await getProfilePicture(
                        session, session.credentials.userIdentityId!);
                  }
                  return null;
                },
                loadOnStart: (req: null),
              ),
            ),
          ],
          child: StyledNavBar(
            listener: (context, navBarState) async {},
            builder: (context, navBarState) => PfpConsumer(
              listener: (context, pfpState) {
                switch (pfpState) {
                  case LoaderLoadedState(data: final image):
                    if (image == null) {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute<void>(
                          builder: (context) => PhotoInstructionsScreen(
                            apiInfo: apiInfo,
                          ),
                        ),
                      );
                    }
                  default:
                }
              },
              builder: (context, pfpState) => switch (pfpState) {
                LoaderLoadedState(data: final image) => LogoutConsumer(
                    listener: (context, logoutState) {
                      switch (logoutState) {
                        case LoaderLoadedState():
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute<void>(
                              builder: (context) =>
                                  LoginScreen(apiInfo: apiInfo),
                            ),
                            (_) => false,
                          );
                        default:
                      }
                    },
                    builder: (context, logoutState) => Expanded(
                      child: switch (navBarState.page) {
                        NavBarPage.news => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('News screen'),
                              const Text('Coming soon'),
                              20.verticalSpace,
                              switch (logoutState) {
                                LoaderLoadingState() =>
                                  const CircularProgressIndicator(),
                                _ => StyledOutlineButton(
                                    onPress: () => context.logoutBloc
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
                              const Text('Coming soon'),
                              20.verticalSpace,
                              switch (logoutState) {
                                LoaderLoadingState() =>
                                  const CircularProgressIndicator(),
                                _ => StyledOutlineButton(
                                    onPress: () => context.logoutBloc
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
                              const Text('Coming soon'),
                              20.verticalSpace,
                              switch (logoutState) {
                                LoaderLoadingState() =>
                                  const CircularProgressIndicator(),
                                _ => StyledOutlineButton(
                                    onPress: () => context.logoutBloc
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
                              const Text('Coming soon'),
                              20.verticalSpace,
                              image ?? const CircularProgressIndicator(),
                              switch (logoutState) {
                                LoaderLoadingState() =>
                                  const CircularProgressIndicator(),
                                _ => StyledOutlineButton(
                                    onPress: () => context.logoutBloc
                                        .add(const LoaderLoadEvent(null)),
                                    text: 'Logout',
                                  ),
                              },
                            ],
                          ),
                      },
                    ),
                  ),
                _ => const CircularProgressIndicator(),
              },
            ),
          ),
        ),
      );
}

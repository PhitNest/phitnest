part of home_page;

class HomePage extends StatelessWidget {
  /// **POP RESULT: NONE**
  ///
  /// This page is the main page of the app. It contains the [ExplorePage],
  /// [ChatPage], [OptionsPage] and [StyledNavBar].
  ///
  /// This page requires the [Cache] to be initialized with [Cache.user],
  /// [Cache.accessToken], [Cache.refreshToken], [Cache.profilePictureUrl],
  /// [Cache.gym] and [Cache.password].
  HomePage({
    Key? key,
  })  : assert(Cache.user != null),
        assert(Cache.accessToken != null),
        assert(Cache.refreshToken != null),
        assert(Cache.profilePictureUrl != null),
        assert(Cache.gym != null),
        assert(Cache.password != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => _HomeBloc(),
        child: BlocConsumer<_HomeBloc, _IHomeState>(
          listener: (context, state) {
            if (state is _LogOutState) {
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (_) => false,
              );
            }
          },
          builder: (context, state) => StyledScaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: 1.sh,
                child: Column(
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          switch (state.currentPage) {
                            case NavbarPage.explore:
                              return ExplorePage(
                                logoPressStream: state.logoPressBroadcast,
                                onSetDarkMode: (darkMode) => context.homeBloc
                                    .add(_SetDarkModeEvent(darkMode)),
                              );
                            case NavbarPage.chat:
                              return const ChatPage();
                            case NavbarPage.options:
                              return const OptionsPage();
                            case NavbarPage.news:
                              return Container();
                          }
                        },
                      ),
                    ),
                    StyledNavBar(
                      page: state.currentPage,
                      onReleaseLogo: () => state.logoPress.add(PressType.up),
                      onPressDownLogo: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                        if (state.currentPage == NavbarPage.explore) {
                          state.logoPress.add(PressType.down);
                        } else {
                          context.homeBloc
                              .add(const _SetPageEvent(NavbarPage.explore));
                        }
                      },
                      animateLogo: state.currentPage == NavbarPage.explore &&
                          !state.freezeLogoAnimation,
                      colorful: state.currentPage == NavbarPage.explore &&
                          (Cache.userExplore?.users.isNotEmpty ?? false),
                      onPressedNews: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                        context.homeBloc
                            .add(const _SetPageEvent(NavbarPage.news));
                      },
                      onPressedExplore: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                        context.homeBloc
                            .add(const _SetPageEvent(NavbarPage.explore));
                      },
                      onPressedOptions: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                        context.homeBloc
                            .add(const _SetPageEvent(NavbarPage.options));
                      },
                      onPressedChat: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                        context.homeBloc
                            .add(const _SetPageEvent(NavbarPage.chat));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

part of home_page;

class HomePage extends StatelessWidget {
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
                  builder: (context) => LoginPage(),
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
                                gymId: Cache.gym!.id,
                                logoPressStream:
                                    state.logoPress.stream.asBroadcastStream(),
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
                        if (state.currentPage == NavbarPage.explore) {
                          state.logoPress.add(PressType.down);
                        } else {
                          context.bloc
                              .add(const _SetPageEvent(NavbarPage.explore));
                        }
                      },
                      onPressedNews: () => context.bloc
                          .add(const _SetPageEvent(NavbarPage.news)),
                      onPressedExplore: () => context.bloc
                          .add(const _SetPageEvent(NavbarPage.explore)),
                      onPressedOptions: () => context.bloc
                          .add(const _SetPageEvent(NavbarPage.options)),
                      onPressedChat: () => context.bloc
                          .add(const _SetPageEvent(NavbarPage.chat)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

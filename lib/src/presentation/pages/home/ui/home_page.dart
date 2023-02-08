part of home_page;

extension HomeBloc on BuildContext {
  _HomeBloc get homeBloc => read();
}

class HomePage extends StatelessWidget {
  final LoginResponse initialData;
  final String initialPassword;

  const HomePage({
    Key? key,
    required this.initialData,
    required this.initialPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => _HomeBloc(
          initialData: initialData,
          initialPassword: initialPassword,
        ),
        child: BlocConsumer<_HomeBloc, _HomeState>(
          listener: (context, state) {},
          builder: (context, state) => Scaffold(
            body: Center(
              child: OptionsPage(
                withAuth: <T>(T Function(String) f) => f(state.accessToken),
                initialGym: state.gym,
                initialUser: state.user,
              ),
            ),
            bottomNavigationBar: StyledNavigationBar(),
          ),
        ),
      );
}

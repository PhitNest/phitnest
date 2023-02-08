part of home_page;

class HomePage extends StatelessWidget {
  final LoginResponse initialData;
  final String initialPassword;

  const HomePage({
    Key? key,
    required this.initialData,
    required this.initialPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OptionsPage(
          withAuth: <T>(T Function(String) f) => f(initialData.accessToken),
          initialGym: initialData.gym,
          initialUser: initialData.user,
        ),
      ),
      bottomNavigationBar: StyledNavigationBar(),
    );
  }
}

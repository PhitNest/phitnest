part of home_page;

class HomePage extends StatelessWidget {
  final String initialAccessToken;
  final String initialRefreshToken;
  final UserEntity initialUserData;
  final String initialPassword;

  const HomePage({
    Key? key,
    required this.initialAccessToken,
    required this.initialRefreshToken,
    required this.initialUserData,
    required this.initialPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Page'),
      ),
      bottomNavigationBar: StyledNavigationBar(),
    );
  }
}

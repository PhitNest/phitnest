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
        child: Text('Home Page'),
      ),
      bottomNavigationBar: StyledNavigationBar(),
    );
  }
}

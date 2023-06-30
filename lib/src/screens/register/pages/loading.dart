part of '../ui.dart';

class RegisterLoadingPage extends StatelessWidget {
  const RegisterLoadingPage({super.key}) : super();

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
